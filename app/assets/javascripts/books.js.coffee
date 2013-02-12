$(document).ready ->
  file_tei_file = $("#file_tei_file")
  file_tiff_file = $("#fileupload")
  file_structmap_file = $("#file_structmap_file")
  tiffFileClearBn = $("#tiff_file_clear")
  teiFileClearBn = $("#tei_file_clear")
  structmapFileClearBn = $("#structmap_file_clear")

  teiFileClearBn.on "click", ->
    file_tei_file.replaceWith file_tei_file.val("").clone(true)

  tiffFileClearBn.on "click", ->
    file_tiff_file.replaceWith file_tiff_file.val("").clone(true)

  structmapFileClearBn.on "click", ->
    file_structmap_file.replaceWith file_structmap_file.val("").clone(true)