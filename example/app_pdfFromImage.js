import TiPDFMerge from 'ti.pdfmerge';

const window = Ti.UI.createWindow();
const btn = Ti.UI.createButton({ title: 'Generate PDF!' });

btn.addEventListener('singletap', () => {
    // Simulate image
    const testImageView = Ti.UI.createView({ width: 2000, height: 2000, borderRadius: 1000, backgroundColor: 'red' });

    // Add inner view to validate that the image is drawn in the correct orientation and coordinate system
    testImageView.add(Ti.UI.createView({ width: 500, height: 500, top: 10, borderRadius: 250, backgroundColor: 'blue' }));
    const testImage = testImageView.toImage();

    // Create the blob and write it
    const blob = TiPDFMerge.pdfFromImage({
        image: testImage,
        resizeImage: true, // NEW: Resize images to fit A4 bounds
        padding: 100 // NEW: left/right padding, only used when "resizeImage" is `true`
    });

    const file = Ti.Filesystem.getFile(Ti.Filesystem.applicationCacheDirectory, 'output.pdf');
    file.write(blob);

    console.warn(file.nativePath);

});

window.add(btn);
window.open();
