#Bootstrap 3.0 Icon Picker

***

If you are looking for a way to create dynamic items(menu,tab,button) with dynamic icon provided by Bootstrap 3 as [glyphicon](http://getbootstrap.com/components/) and need a picker like color picker or date picker from where you can select the icon and corresponding icon-class goes to your form field(input) you are in right place!

## Demo

Do you want to see directives in action? Visit http://titosust.github.io/Bootstrap-icon-picker

## Installation

#### HTML HEAD:
```
<link href="css/bootstrap.min.css" rel="stylesheet" type="text/css" />
<link href="css/icon-picker.min.css"  rel="stylesheet" type="text/css" />
<script src="js/jquery.min.js"></script>
<script src="js/iconPicker.min.js"></script>
```

#### JavaScript:
```
<script type="text/javascript">
        $(function () {
            $(".icon-picker").iconPicker();
        });
</script>
```

#### HTML BODY:
```
<form method="post" >
<input type="text" name="someName" class="icon-picker" />
</form>
```

<p>And you are done!</p>
