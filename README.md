# PsWeather
Weather module for PowerShell

##Install instructions
This module is available on the [PowerShell Gallery](https://www.powershellgallery.com/packages/PsWeather). Instructions are available on the site for global installation, but if you need to install without admin rights to your profile, simply open a PS session and type one of the following commands.

```PowerShell
Install-Package PsWeather -Scope CurrentUser
```
or
```PowerShell
Install-Module PsWeather -Scope CurrentUser
```

##Usage
Once installed you can run the command and pass in the zipcode [-zip=17055] and number of days [-days=7].
```PowerShell
weather 17055 7
```
or
```PowerShell
weather -zip 17055 -days 7
```
