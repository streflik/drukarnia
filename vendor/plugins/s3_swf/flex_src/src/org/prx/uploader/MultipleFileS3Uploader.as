package org.prx.uploader {

    import com.adobe.net.MimeTypeMap;
    
    import com.elctech.S3UploadOptions;
    import com.elctech.S3UploadRequest;

    import mx.collections.ArrayCollection;
    import mx.controls.Alert;
    import mx.controls.Button;
    import mx.controls.DataGrid;
    import mx.controls.dataGridClasses.*;
    import mx.controls.Label;
    import mx.controls.ProgressBar;
    import mx.controls.ProgressBarMode;
    import mx.events.CollectionEvent;
    import mx.formatters.DateFormatter;

    import flash.events.*;
    import flash.external.ExternalInterface;
    import flash.net.FileFilter;
    import flash.net.FileReference;
    import flash.net.FileReferenceList;
    import flash.net.URLRequest;
    import flash.net.URLLoader;
    import flash.net.URLVariables;
    import flash.net.URLRequestMethod;
    import flash.net.URLLoaderDataFormat;

    public class MultipleFileS3Uploader {

        //UI Vars
        private var _signatureUrl:String;
        private var _prefixPath:String;
        private var _browseButton:Button;
        private var _removeSelectedButton:Button;
        private var _removeAllButton:Button;
        private var _uploadButton:Button;
        private var _uploadProgressBar:ProgressBar;
        private var _filesDataGrid:DataGrid;
        private var _dateTimeFormatter:DateFormatter;

        //DataGrid Columns
        private var _nameColumn:DataGridColumn;
        private var _sizeColumn:DataGridColumn;
        private var _updatedColumn:DataGridColumn;
        private var _columns:Array;
        
        //File Reference Vars
        [Bindable]
        private var _files:ArrayCollection;
        private var _fileref:FileReferenceList
        private var _file:FileReference;
        private var _totalbytes:Number;
        
        //config vars
        private var _options:S3UploadOptions;
        private var _maxFileCount:Number;
        private var _maxFileSize:Number; //bytes

        private var _mimeMap:MimeTypeMap;
        private var _fileFilter:FileFilter;

        public var s3onSuccessCall:String;
        public var s3onFailedCall:String;
        public var s3onSelectedCall:String;
        public var s3onInfoCall:String;
        public var s3onCancelCall:String;

        public function MultipleFileS3Uploader(signatureUrl:String,
                                               initialMessage:String,
                                               prefixPath:String,
                                               maxFileSize:String,
                                               fileTypes:String,
                                               fileTypeDescs:String,
                                               browseButton:Button,
                                               uploadButton:Button,
                                               removeSelectedButton:Button,
                                               removeAllButton:Button,
                                               uploadProgressBar:ProgressBar,
                                               filesDataGrid:DataGrid) {
            // set up from args
            _prefixPath = prefixPath;
            _signatureUrl = signatureUrl;
            _browseButton = browseButton;
            _uploadButton = uploadButton;
            _removeSelectedButton = removeSelectedButton;
            _removeAllButton = removeAllButton;
            _uploadProgressBar = uploadProgressBar;
            _filesDataGrid = filesDataGrid;

            // other defaults
            _maxFileCount = 10;
            _mimeMap = new MimeTypeMap();
            _fileFilter = new FileFilter(fileTypeDescs, fileTypes);
            _maxFileSize = parseInt(maxFileSize);
            _dateTimeFormatter = new DateFormatter();
            /*_dateTimeFormatter.formatString = "MM/DD/YYYY L:NN A";*/
            _dateTimeFormatter.formatString = "MM/DD/YY";
	        _totalbytes = 0;

            // js callback functions
            s3onSuccessCall  = "s3_swf.onSuccess";
            s3onFailedCall   = "s3_swf.onFailed";
            s3onSelectedCall = "s3_swf.onSelected";
            s3onInfoCall     = "s3_swf.onInfo";
            s3onCancelCall   = "s3_swf.onCancel";
            
	        ExternalInterface.call(s3onInfoCall, initialMessage);

            init();
        }
        
        private function init():void {
            // Create options list for file s3 upload metadata 
            _options = new S3UploadOptions();

	        // Setup File Array Collection and FileReference
	        _files = new ArrayCollection();
	        _fileref = new FileReferenceList;
	        _file = new FileReference;

            // Add Event Listeners to UI 
            _browseButton.addEventListener(MouseEvent.CLICK, browseFiles);
            _removeAllButton.addEventListener(MouseEvent.CLICK, clearFileQueue);
            _removeSelectedButton.addEventListener(MouseEvent.CLICK, removeSelectedFileFromQueue);
            _uploadButton.addEventListener(MouseEvent.CLICK, uploadFiles);

            _fileref.addEventListener(Event.SELECT, selectHandler);
            _files.addEventListener(CollectionEvent.COLLECTION_CHANGE, popDataGrid);

	        // Set Up UI Buttons;
	        _uploadButton.enabled = false;
	        _removeSelectedButton.enabled = false;
	        _removeAllButton.enabled = false;
	        
	        // Set Up DataGrid UI
	        _nameColumn = new DataGridColumn;
	        _sizeColumn = new DataGridColumn;
	        _updatedColumn = new DataGridColumn;
	            
	        _nameColumn.dataField = "name";
	        _nameColumn.headerText= "File";

	        _sizeColumn.dataField = "size";
	        _sizeColumn.headerText = "Size";
	        _sizeColumn.labelFunction = bytesColumnToString as Function;
	        _sizeColumn.width = 52;

	        _updatedColumn.dataField = "modificationDate";
	        _updatedColumn.headerText = "Modified";
            _updatedColumn.labelFunction = dateTimeColumnToString as Function;
	        _updatedColumn.width = 64;
	        
	        _columns = new Array(_nameColumn, _sizeColumn, _updatedColumn);
	        _filesDataGrid.columns = _columns
	        _filesDataGrid.sortableColumns = false;
	        _filesDataGrid.dataProvider = _files;
	        _filesDataGrid.dragEnabled = false;
	        _filesDataGrid.dragMoveEnabled = false;
	        _filesDataGrid.dropEnabled = false;
        }

        //Browse for files
        private function browseFiles(event:Event):void{        
            _fileref.browse([_fileFilter]);
        }

        //  called after user selected files form the browse dialouge box.
        private function selectHandler(event:Event):void {
            var i:int;
            var msg:String ="";
            var dl:Array = [];
            for (i=0;i < event.currentTarget.fileList.length; i ++){
            	if (checkFileSize(event.currentTarget.fileList[i].size)){
                    _files.addItem(event.currentTarget.fileList[i]);
                    trace("under size " + event.currentTarget.fileList[i].size);
			        ExternalInterface.call(s3onSelectedCall, 
			                               event.currentTarget.fileList[i].name,
			                               event.currentTarget.fileList[i].size,
			                               getContentType(event.currentTarget.fileList[i].name));
            	}  else {
                	dl.push(event.currentTarget.fileList[i]);
			        ExternalInterface.call(s3onFailedCall,
			                               event.currentTarget.fileList[i].name + " too large, max is " + Math.round(_maxFileSize / 1024) + " kb");
            	}
            }	            

            /* Don't do this here, just make the external interface call above. */
            /*if (dl.length > 0) {
                for (i=0;i<dl.length;i++) {
                    msg += String(dl[i].name + " is too large. \n");
                }
                    mx.controls.Alert.show(msg + "Max File Size is: " + Math.round(_maxFileSize / 1024) + " kb","File Too Large",4,null).clipContent;
            }*/
            
            if(_files.length > 0) {
    	        ExternalInterface.call(s3onInfoCall, "Click 'Upload' to start loading files, or 'Browse...' to select more.");
            }
        }
        
        private function getSignature():void {
            var request:URLRequest     = new URLRequest(_signatureUrl);
            var loader:URLLoader       = new URLLoader();
            var variables:URLVariables = new URLVariables();

            _options.FileSize          = _file.size.toString();
            _options.FileName          = getFileName(_file);
	        _options.ContentType       = getContentType(_options.FileName);
	        _options.key               = _prefixPath + _options.FileName;

            variables.key              = _options.key
            variables.content_type     = _options.ContentType;

            request.method             = URLRequestMethod.GET;
            request.data               = variables;
            loader.dataFormat          = URLLoaderDataFormat.TEXT;
            
            loader.addEventListener(Event.COMPLETE, sigCompleteHandler);
            loader.addEventListener(Event.OPEN, sigOpenHandler);
            loader.addEventListener(ProgressEvent.PROGRESS, sigProgressHandler);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, sigSecurityErrorHandler);
            loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, sigHttpStatusHandler);
            loader.addEventListener(IOErrorEvent.IO_ERROR, sigIoErrorHandler);

            loader.load(request);
        }

        private function sigCompleteHandler(event:Event):void {
            var loader:URLLoader = URLLoader(event.target);
            var xml:XML  = new XML(loader.data);
            
            // create the s3 options object
            _options.policy         = xml.policy;
            _options.signature      = xml.signature;
            _options.bucket         = xml.bucket;
            _options.AWSAccessKeyId = xml.accesskeyid;
            _options.acl            = xml.acl;
            _options.Expires        = xml.expirationdate;
            _options.Secure         = xml.https;

            if (xml.errorMessage != "") {
                resetProgressBar();
                _uploadButton.enabled = true;
                ExternalInterface.call(s3onFailedCall, "Error! Please try again, or contact us for help.");
                return;
            }

            var request:S3UploadRequest = new S3UploadRequest(_options);
            request.addEventListener(Event.OPEN, s3OpenHandler);
            request.addEventListener(ProgressEvent.PROGRESS, s3ProgressHandler);
            request.addEventListener(IOErrorEvent.IO_ERROR, s3IoErrorHandler);
            request.addEventListener(SecurityErrorEvent.SECURITY_ERROR, s3SecurityErrorHandler);
            request.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, s3CompleteHandler);

            try {
    	        ExternalInterface.call(s3onInfoCall, "Upload started...");
                request.upload(_file);
            } catch(e:Error) {
                ExternalInterface.call(s3onFailedCall, "Upload error!");
                trace("An error occurred: " + e);
            }
        }

        // called after the file is opened before upload    
        private function s3OpenHandler(event:Event):void{
	        ExternalInterface.call(s3onInfoCall, "");
            trace(event);
            trace('openHandler triggered');
            _files;
        }

        // called during the file upload of each file being uploaded | we use this to feed the progress bar its data
        private function s3ProgressHandler(event:ProgressEvent):void {        
            _uploadProgressBar.setProgress(event.bytesLoaded,event.bytesTotal);
            _uploadProgressBar.label = "Uploaded " + bytesToString(event.bytesLoaded) + " of " + bytesToString(event.bytesTotal) + ", " + (_files.length - 1) + " files remaining";
        }

        // only called if there is an  error detected by flash player browsing or uploading a file   
        private function s3IoErrorHandler(event:IOErrorEvent):void{
            //trace('And IO Error has occured:' +  event);
            trace(s3onFailedCall);
            ExternalInterface.call(s3onFailedCall, "Error! Please retry, or contact us for help: " + String(event));
            /*trace(event);*/
            /*mx.controls.Alert.show(String(event),"ioError",0);*/
        }    

        // only called if a security error detected by flash player such as a sandbox violation
        private function s3SecurityErrorHandler(event:SecurityErrorEvent):void{
            //trace("securityErrorHandler: " + event);
            trace(s3onFailedCall);
            ExternalInterface.call(s3onFailedCall, "Error, access denied: " + String(event));
            /*trace(event);*/
            /*mx.controls.Alert.show(String(event),"Security Error",0);*/
        }
        //  This function its not required
        private function s3CancelHandler(event:Event):void{
            // cancel button has been clicked;
            trace('cancelled');
        }
        
        private function s3CompleteHandler(event:Event):void{
            //trace('completeHanderl triggered');
            trace(s3onSuccessCall);
            ExternalInterface.call(s3onSuccessCall, _options.FileName, _options.FileSize, _options.ContentType);
            trace(event);
            _files.removeItemAt(0);
            if (_files.length > 0){
            	_totalbytes = 0;
                uploadFiles(null);
            } else {
                setupCancelButton(false);
                 _uploadProgressBar.label = "Uploads complete";
     	        ExternalInterface.call(s3onInfoCall, "All uploads complete");
                /* not sure these next 2 lines are necessary... */
                 var uploadCompleted:Event = new Event(Event.COMPLETE);
                dispatchEvent(uploadCompleted);
            }
        }    

        private function getContentType(fileName:String):String {
	        var fileNameArray:Array    = fileName.split(/\./);
	        var fileExtension:String   = fileNameArray[fileNameArray.length - 1];
	        var contentType:String     = _mimeMap.getMimeType(fileExtension);
	        return contentType;
        }
        
        private function getFileName(file:FileReference):String {
            var fileName:String = file.name.replace(/^.*(\\|\/)/gi, '').replace(/[^A-Za-z0-9\.\-]/gi, '_');
            return fileName;
        }

        private function sigOpenHandler(event:Event):void {
 	        ExternalInterface.call(s3onInfoCall, "Preparing...");
            trace("openHandler: " + event);
        }
        private function sigProgressHandler(event:ProgressEvent):void {
            trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
        }
        private function sigSecurityErrorHandler(event:SecurityErrorEvent):void {
            trace("securityErrorHandler: " + event);
            ExternalInterface.call(s3onFailedCall, "Security error!");
            /*mx.controls.Alert.show(String(event),"securityError",0);*/
        }
        private function sigHttpStatusHandler(event:HTTPStatusEvent):void {
            trace("httpStatusHandler: " + event);
        }
        private function sigIoErrorHandler(event:IOErrorEvent):void {
            trace("ioErrorHandler: " + event);
            trace(s3onFailedCall);
            ExternalInterface.call(s3onFailedCall, "Network error!");
            /*mx.controls.Alert.show(String(event),"networkError",0);*/
        }

        private function uploadFiles(event:Event):void{
            if (_files.length > 0){
     	        ExternalInterface.call(s3onInfoCall, 'Initiating...');
                _file = FileReference(_files.getItemAt(0));
                getSignature();
                setupCancelButton(true);
            }
        }

        //Remove Selected File From Queue
        private function removeSelectedFileFromQueue(event:Event):void{
            if (_filesDataGrid.selectedIndex >= 0){
                _files.removeItemAt( _filesDataGrid.selectedIndex);
            }
        }

		 //Remove all files from the upload cue;
        private function clearFileQueue(event:Event):void{
            _files.removeAll();
        }

		// Cancel Current File Upload
        private function cancelFileIO(event:Event):void{
            _file.cancel();
            setupCancelButton(false);
            checkQueue();
        }    

        // Checks the files do not exceed maxFileSize | if _maxFileSize == 0 No File Limit Set
        private function checkFileSize(filesize:Number):Boolean{
        	var r:Boolean = false;
    		//if  filesize greater then _maxFileSize
	        if (filesize > _maxFileSize){
	        	r = false;
	        	trace("false");
	       	 }else if (filesize <= _maxFileSize){
	        	r = true;
	        	trace("true");
        	}
        	
        	if (_maxFileSize == 0){
        	r = true;
        	}
	   	
        	return r;
        }


		//label function for the datagird File Size Column
        private function bytesColumnToString(data:Object,blank:Object):String {
            return bytesToString(data.size);
        }

		//label function for the datagird File Size Column
        private function bytesToString(bytes:Number):String {
            var byteString:String;
            var kiloBytes:Number;
            kiloBytes = bytes / 1024;
            if (kiloBytes > 1024) {
                byteString = String(Math.round(kiloBytes / 1024)) + ' mb';
            } else {
                byteString = String(Math.round(kiloBytes)) + ' kb';
            }
            return byteString
        }

        // Feed the progress bar a meaningful label
        private function getByteCount():void{
	        var i:int;
	        _totalbytes = 0;
            for(i=0;i < _files.length;i++){
                _totalbytes +=  _files[i].size;
            }
	        _uploadProgressBar.label = "Total Files: "+  _files.length + " Total Size: " + bytesToString(_totalbytes);
        }        
        
        private function dateTimeColumnToString(data:Object, column:DataGridColumn):String {
            var dateString:String;
            dateString = _dateTimeFormatter.format(data.modificationDate);
            return dateString;
        }

         // restores progress bar back to normal
         private function resetProgressBar():void{
            _uploadProgressBar.label = "";
            _uploadProgressBar.maximum = 0;
            _uploadProgressBar.minimum = 0;
         }

         // reset form item elements
         private function resetForm():void{
             _uploadButton.enabled = false;
             _uploadButton.addEventListener(MouseEvent.CLICK, uploadFiles);
             _uploadButton.label = "Upload";
             _uploadProgressBar.maximum = 0;
             _totalbytes = 0;
             _uploadProgressBar.label = "";
             _removeSelectedButton.enabled = false;
             _removeAllButton.enabled = false;
             _browseButton.enabled = true;
         }

         // whenever the _files arraycollection changes this function is called to make sure the datagrid data jives
         private function popDataGrid(event:CollectionEvent):void{                
             getByteCount();
             checkQueue();
         }

        // enable or disable upload and remove controls based on files in the cue;        
         private function checkQueue():void{
              if (_files.length > 0){
                 _uploadButton.enabled = true;
                 _removeSelectedButton.enabled = true;
                 _removeAllButton.enabled = true;            
              }else{
                 resetProgressBar();
                 _uploadButton.enabled = false;     
              }    
         }

     	// toggle upload button label and function to trigger file uploading or upload cancelling
         private function setupCancelButton(x:Boolean):void{
             if (x == true){
                 _uploadButton.label = "Cancel";
                 _browseButton.enabled = false;
                 _removeSelectedButton.enabled = false;
                 _removeAllButton.enabled = false;
                 _uploadButton.removeEventListener(MouseEvent.CLICK, uploadFiles);
                 _uploadButton.addEventListener(MouseEvent.CLICK,cancelFileIO);        
             }else if (x == false){
                 _uploadButton.removeEventListener(MouseEvent.CLICK,cancelFileIO);
                 _uploadButton.addEventListener(MouseEvent.CLICK, uploadFiles);
                 resetForm();
             }
         }

    }
}
