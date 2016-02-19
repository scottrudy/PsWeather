Function Get-Weather
{
    <#
    .Synopsis
       PowerShell Weather Forecast
    .EXAMPLE
       Get-Weather
    .EXAMPLE
       Get-Weather -zip 17055 -days 7
    #>
    Param(
      [Parameter(Position=0)]
      [string]
      $zip=17055,
      [Parameter(Position=1)]
      [int]
      $days=7
    )
    Get-WeatherFromNoaa -zip $zip -days $days | Format-Table -Property date, maxTemp, minTemp, Summary -AutoSize
}

Function Get-WeatherFromNoaa
{
    Param([string]$zip, [int]$days)

    $URI = "http://www.weather.gov/forecasts/xml/DWMLgen/wsdl/ndfdXML.wsdl"
    $Proxy = New-WebServiceProxy -uri $URI -namespace WebServiceProxy

    [xml]$latlon=$proxy.LatLonListZipCode($zip)

    foreach($l in $latlon)
    {
        $a = $l.dwml.latlonlist -split ","
        $lat = $a[0]
        $lon = $a[1]
        $unit = "e"
        $sDate = get-date -UFormat %Y-%m-%d
        $format = "Item24hourly"

        [xml]$weather = $Proxy.NDFDgenByDay($lat,$lon,$sDate,$days,$unit,$format)

        for($i=0; $i-le$days - 1; $i++)
        {
            New-Object PSObject -Property @{
                "Date" = ((Get-Date).addDays($i)).tostring("MM/dd/yyyy") ;
                "maxTemp" = $weather.dwml.data.parameters.temperature[0].value[$i] ;
                "minTemp" = $weather.dwml.data.parameters.temperature[1].value[$i] ;
                "Summary" = $weather.dwml.data.parameters.weather."weather-conditions"[$i]."Weather-summary"
            }
        }
    }
}
