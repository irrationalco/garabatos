# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('#products-table').dataTable
    bStateSave: true #this causes the state to save between navigations
    processing: true
    serverSide: true
    ajax: $('#products-table').data('source')
    pagingType: 'full_numbers'
    columns: [
      {data: 'name'}
      {data: 'types'}
      {data: 'categories'}
      {data: 'sets'}
      {data: 'codes'}
    ]