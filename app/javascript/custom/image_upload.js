// Prevent uploading of big images.
document.addEventListener("turbo:load", function () {
  document.addEventListener("change", function (event) {
    const imageUpload = document.querySelector("#micropost_image");
    if (!imageUpload || !imageUpload.files || imageUpload.files.length === 0)
      return;

    const sizeInMegabytes = imageUpload.files[0].size / 1024 / 1024;
    if (sizeInMegabytes > 5) {
      alert(t("microposts.image.too_large"));
      imageUpload.value = "";
    }
  });
});
