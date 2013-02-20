$(document).ready ->
  file_tei_file = $("#file_tei_file")
  teiFileClearBn = $("#tei_file_clear")

  portrait_portrait_file = $("#portrait_portrait_upload")
  portraitFileClearBn = $("#portrait_file_clear")

  teiFileClearBn.on "click", ->
    file_tei_file.replaceWith file_tei_file.val("").clone(true)

  portraitFileClearBn.on "click", ->
    portrait_portrait_file.replaceWith portrait_portrait_file.val("").clone(true)
