# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

removeParentElement = (child) ->
  element = child.parent()
  numberOfSiblings = element.siblings().length

  if numberOfSiblings > 1
    element.remove()

cloneFirstElement = (element) ->
  element.first().clone().find('input').val('')

addLogicToFieldForm = (formName) ->
  add = "##{formName}_add"
  element = ".#{formName}_element"
  list = "##{formName}_list"
  del = ".#{formName}_delete"

  $(add).click(-> cloneFirstElement($(element)).appendTo(list))
  $(list).on 'click', del, -> removeParentElement $(@)


$ ->
  addLogicToFieldForm("external")
  addLogicToFieldForm("quote")
  addLogicToFieldForm("timeline")



