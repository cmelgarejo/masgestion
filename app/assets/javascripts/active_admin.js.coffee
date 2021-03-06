#= require active_admin/base
# #= require active_material
#= require chartkick
#= require selectize
#= require activeadmin-ajax_filter
#= require palette-color-picker
#= require select2
#= require select2_locale_es
#= require country_state_select
#= require chosen-jquery
#= require ymaps
$(document).ready ->
  if($('.color-reference-select option:selected').length > 0)
    $('.color-reference-select > option').each((i, el) -> $(el).css('background-color', el.innerHTML).css('color', el.innerHTML))
    color = $('.color-reference-select option:selected')[0].innerHTML
    $('.color-reference-select').css('background-color', color).css('color', color)
    $('.color-reference-select').change -> color = $('.color-reference-select option:selected')[0].innerHTML
    $('.color-reference-select').css('background-color', color).css('color', color)

  $('.color-picker').paletteColorPicker()
  $( ".select2" ).select2() #if window.location.pathname.match(/(client.*\/\/edit|users\/.*\/edit|client.*\/new|client.*\/new)/)

  if window.location.pathname.match(/.*clients.*\/edit/)
    $('li[id^="client_client_collection_history_attributes_"][class^=hidden]').remove()
    $('.button.has_many_add').click ->
      setTimeout ->
        $('.button.has_many_add').prev().css('display','inherit')
      , 100

  CountryStateSelect({
    country_id: "client_country", state_id: "client_state", city_id: "client_city",
    chosen_ui: true,
    chosen_options: {
      disable_search_threshold: 10,
      width: '65%',
      city_place_holder: "Selecciona una ciudad", state_place_holder: 'Selecciona una región'
    }
  })

#  CountryStateSelect({
#    country_id: "user_locations_attributes_0_country", state_id: "user_locations_attributes_0_state", city_id: "user_locations_attributes_0_city",
#    chosen_ui: false,
#    chosen_options: {
#      disable_search_threshold: 10,
#      width: '65%',
#      city_place_holder: "Selecciona una ciudad", state_place_holder: 'Selecciona una región'
#    }
#  })