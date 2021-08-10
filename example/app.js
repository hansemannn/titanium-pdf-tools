import TiPDFMerge from 'ti.pdfmerge';

const window = Ti.UI.createWindow({
	backgroundColor: '#fff'
});

const btn = Ti.UI.createButton({ title: 'Merge PDF\'s!' });

btn.addEventListener('click', () => {
	const paths = [
		Ti.Filesystem.getFile(Ti.Filesystem.resourcesDirectory, 'test1.pdf').nativePath,
		Ti.Filesystem.getFile(Ti.Filesystem.resourcesDirectory, 'test2.pdf').nativePath
	];

	const document = TiPDFMerge.mergedPDF(paths);
	const file = Ti.Filesystem.getFile(Ti.Filesystem.applicationCacheDirectory, 'document.pdf');
	file.write(document);

	console.warn('Merged PDF URL => ' + file.nativePath);
});

window.add(btn);
window.open();