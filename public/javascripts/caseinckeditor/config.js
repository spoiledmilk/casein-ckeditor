CKEDITOR.editorConfig = function(config) {
	config.language = 'en';
	
	config.toolbar = 'CaseinCk_Basic';
  
  config.toolbar_CaseinCk_Basic =
    [
        ['Source','Cut','Copy','Paste','PasteText','PasteFromWord'],
				'/',
				['Format','Bold','Italic','-','NumberedList','BulletedList','-','Link','Unlink','Anchor','-','Table','HorizontalRule','Image','RemoveFormat']
    ];
};
