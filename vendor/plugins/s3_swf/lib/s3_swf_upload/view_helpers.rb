module S3SwfUpload
  module ViewHelpers
    def s3_swf_upload_tag(options = {})
      height                 = options[:height] || 175
      width                  = options[:width]  || 550
      success                = options[:success]  || ''
      failed                 = options[:failed]  || ''
      selected               = options[:selected]  || ''
      canceled               = options[:canceled] || ''
      info                   = options[:info] || ''
      prefix                 = options[:prefix] || ''
      upload                 = options[:upload] || 'Prześlij'
      initial_message        = options[:initial_message] || 'Wybierz pliki do przesłania...'      
      max_file_size          = options[:max_file_size] || '314572800'
      file_types             = options[:file_types] || "*.*"
      file_type_descriptions = options[:file_type_descriptions] || "Wszystkie pliki"

      prefix                 = prefix + "/" unless prefix == ""

      @include_s3_upload ||= false 
      @count ||= 1
      
      out = ""

      if !@include_s3_upload
        out << javascript_include_tag('s3_upload')
        @include_s3_upload = true
      end

      out << %(<a name="uploadform#{@count}"></a>
            <script type="text/javascript">
            var s3_swf#{@count} = s3_swf_init('s3_swf#{@count}', {
              wmode: 'transparent',
              width:  #{width},
              height: #{height},
              fileTypes: '#{file_types}',
              fileTypeDescs: '#{file_type_descriptions}',
              initialMessage: '#{initial_message}',
              prefix: '#{prefix}',
              onSuccess: function(filename, filesize, contenttype){
                #{success}
              },
              onFailed: function(status){
                #{failed}
              },
              onFileSelected: function(filename, size, contenttype){
                #{selected}
              },
              onInfo:  function(status){
                #{info}
              },
              onCancel:  function(status){
                #{canceled}
              }
            });
        </script>

        <div id="s3_swf#{@count}">
          Please <a href="http://www.adobe.com/go/getflashplayer">Update</a> your Flash Player to Flash v9.0.1 or higher...
        </div>
      )
      
      @count += 1
      out
    end

  end
end

ActionView::Base.send(:include, S3SwfUpload::ViewHelpers)
