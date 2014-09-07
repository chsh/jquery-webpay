$ = jQuery

$.fn.extend
  webpay: (options) ->
    # Default settings
    settings =
      card_ids:
        number: '#card-number'
        name: '#card-name'
        exp_month: '#card-exp-month'
        exp_year: '#card-exp-year'
        cvc: '#card-cvc'
      token_id: '#card-token'
      prepare_required: true
      debug: false

    settings = $.extend settings, options

    me = $(this)

    log = (msg) ->
      console?.log msg if settings.debug

    setup_required = ->
      $(settings.card_ids.number, me).attr pattern: "[0-9]{15,16}", required: "required"
      $(settings.card_ids.name, me).attr pattern: "[A-Z]+( [A-Z]+)+", required: "required"
      $(settings.card_ids.exp_month, me).attr pattern: "0?[1-9]|10|11|12", required: "required"
      $(settings.card_ids.exp_year, me).attr pattern: "1[4-9]|[2-4][0-9]", required: "required"
      $(settings.card_ids.cvc, me).attr pattern: "[0-9]{3,4}", required: "required"

    setup_form = ->
      if $(settings.token_id, me).val() is ""
        $('button', me).prop "disabled", true
        card =
          number: $(settings.card_ids.number, me).val()
          name: $(settings.card_ids.name, me).val()
          cvc: $(settings.card_ids.cvc, me).val()
          exp_month: $(settings.card_ids.exp_month, me).val()
          exp_year: $(settings.card_ids.exp_year, me).val()
        WebPay.createToken card, response_handler
        return false
      true

    response_handler = (status, response) ->
      if response.error
        $('button', me).prop "disabled", false
        log response.error
        alert response.error
      else
        $(settings.token_id, me).val response.id
        $(settings.card_ids.number, me).val('')
        $(settings.card_ids.name, me).val('')
        $(settings.card_ids.exp_month, me).val('')
        $(settings.card_ids.exp_year, me).val('')
        $(settings.card_ids.cvc, me).val('')
        log response.id
        me.submit()

    WebPay.setPublishableKey "{WEBPAY_PUBLIC_KEY}"
    setup_required() if settings.prepare_required
    me.submit setup_form

