Add-Type -Assembly System.Windows.Forms
Add-Type -AssemblyName PresentationFramework

[xml]$xaml = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    x:Name="Window" WindowStyle="None" 
    Width= "260" Height="140"
    Background="{DynamicResource {x:Static SystemColors.ControlDarkBrushKey}}"
    AllowsTransparency="True">
    <Window.Clip>
        <RectangleGeometry Rect="0,0,260,140" RadiusX="20" RadiusY="20"/>
    </Window.Clip>
    <Grid x:Name="Grid">
        <Button x:Name="button1" Content="Close" HorizontalAlignment="Left"
         VerticalAlignment="Top" Width="75" Margin="10,10,0,0">
        </Button>
    </Grid>
</Window>
"@
$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)
$button1 = $window.FindName("button1")
$button1.Add_Click({
   $window.Close();
})
$window.ShowDialog()