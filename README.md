# User Interface elements
User interface elements served as components.

## Documentation

### Code
The code is documented thanks to jsDoc. Check the source code for more detail.

### Demos
Please refer to our live documentation.

This is the way to see are live demos:

* Execute the serve command
```
$ gulp serve
```

* Open the demos page in a browser:
```
http://localhost:3000/doc/demos/
```


## Components

### syn-nav-stack
Multi level menu.

#### Options

| Name | Type | Description |
|------|------|-------------|
| nav | {Object} | List of buttons to add |
| nav.foo | {Object}| Definition of a button |
| head.foo.label | {String}| Name of the button |
| head.foo.nav | {String}| List of children buttons |
| head.foo.id | {String}| Unique id (optional) (default: foo) |
| head.foo.classes | {Array}| List of css classes to add to DOM Element |
| head.foo.on | {Object}| List of event handlers|
| head.foo.on.foo | {Function}| Event handler |
| [ active ] | {string} | Default active button |

```coffeescript

{
  nav:
    televisions:
      label: 'Televisions'
      classes: [ 'tv-icon' ]
      on:
        click: ( item ) -> alert( item.label )
        keypress: ( item, event ) -> alert( event.keyCode )
      nav:
        smart: 'Smart TV'
        led: 'LED'
        plasma: 'Plasma'
    cameras:
      label: 'Cameras'
}
```
