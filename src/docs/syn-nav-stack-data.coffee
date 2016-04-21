( ( win ) ->
  config =
    nav:
      store:
        label: 'Store'
        nav:
          clothes:
            label: 'Clothes'
            nav:
              women:
                label: 'Women\'s'
                classes: [ '-pink' ]
                nav:
                  top: 'Tops'
                  dress: 'Dresses'
                  trousers: 'Trousers'
                  shoes: 'Shoes'
              men:
                label: 'Men\'s'
                classes: [ '-blue' ]
                nav:
                  shirts: 'Shirts'
                  shoes: 'Shoes'
          jewelry: 'Jewerly'
      manage:
        label: 'Devices'
        nav:
          phones:
            label: 'Mobile Phones'
            nav:
              iphone: 'iPhone'
              galaxy: 'Galaxy'
              nexus: 'Nexus'
          televisions:
            label: 'Televisions'
            nav:
              smart: 'Smart TV'
              led: 'LED'
              plasma: 'Plasma'
          cameras:
            label: 'Cameras'

  win.syn ?= {}
  win.syn.demos ?= {}
  win.syn.demos._navStackData = config
)( window )
