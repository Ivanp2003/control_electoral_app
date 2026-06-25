param(
  [Parameter(Mandatory = $true)]
  [string]$Endpoint,
  [Parameter(Mandatory = $true)]
  [string]$ProjectId
)

Write-Host "=== Control Electoral Ecuador - Build APK Release ===" -ForegroundColor Cyan
Write-Host "Endpoint: $Endpoint" -ForegroundColor Gray
Write-Host "ProjectId: $ProjectId" -ForegroundColor Gray
Write-Host ""

flutter clean
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

flutter pub get
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "`nEjecutando análisis estático..." -ForegroundColor Yellow
dart analyze lib/
if ($LASTEXITCODE -ne 0) {
  Write-Host "⚠  El análisis encontró problemas. Revisa antes de continuar." -ForegroundColor Yellow
  $continue = Read-Host "¿Continuar de todas formas? (s/N)"
  if ($continue -ne "s") { exit 1 }
}

Write-Host "`nEjecutando pruebas..." -ForegroundColor Yellow
flutter test --no-pub
if ($LASTEXITCODE -ne 0) {
  Write-Host "❌ Las pruebas fallaron. Abortando." -ForegroundColor Red
  exit 1
}

Write-Host "`nCompilando APK Release..." -ForegroundColor Green
flutter build apk --release `
  --dart-define=APPWRITE_ENDPOINT=$Endpoint `
  --dart-define=APPWRITE_PROJECT_ID=$ProjectId

if ($LASTEXITCODE -eq 0) {
  Write-Host "`n✅ APK generado en: build/app/outputs/flutter-apk/app-release.apk" -ForegroundColor Green
} else {
  Write-Host "`n❌ Error al compilar APK." -ForegroundColor Red
  exit 1
}
