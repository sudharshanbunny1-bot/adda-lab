$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:8082/")
$listener.Start()
Write-Host "NoteVault server is live on http://localhost:8082/"

$baseDir = "C:\Users\sudha\.gemini\antigravity\scratch\spring-docker-aws\src\main\resources\templates"

while ($listener.IsListening) {
    $context = $listener.GetContext()
    $request = $context.Request
    $response = $context.Response

    $path = $request.Url.AbsolutePath
    Write-Host "[$((Get-Date).ToString('HH:mm:ss'))] $($request.HttpMethod) $path"

    $filePath = "$baseDir\login.html"
    if ($path -eq "/notes") {
        $filePath = "$baseDir\notes.html"
    } elseif ($path -eq "/login" -and $request.HttpMethod -eq "POST") {
        # Redirect to /notes after login
        $response.StatusCode = 302
        $response.RedirectLocation = "/notes"
        $response.OutputStream.Close()
        continue
    }

    if (Test-Path $filePath) {
        $content = [System.IO.File]::ReadAllBytes($filePath)
        $response.ContentType = "text/html; charset=utf-8"
        $response.ContentLength64 = $content.Length
        $response.OutputStream.Write($content, 0, $content.Length)
    } else {
        $response.StatusCode = 404
        $msg = [System.Text.Encoding]::UTF8.GetBytes("404 Not Found")
        $response.OutputStream.Write($msg, 0, $msg.Length)
    }

    $response.OutputStream.Close()
}
