# bate_ponto_mobile

## Android Studio
Instale o Android Studio porque ele vai preparar a SDK do Android
para você. É mais confiável que vai dar certo do que você tentar
instalar apenas a SDK sozinho, te poupando tempo e sanidade.

Abra o Android Studio e vá até Tools > SDK Manager.
Selecione a SDK 23 na aba SDK Plataforms e depois
vá em SDK tools e selecione Android SDK Command-line Tools.
Instale tudo isso e se quiser pode só usar o VS Code agora.
Depois de tudo isso vamos instalar o Flutter.

## Instalar Flutter (Ubuntu)

Clone o repositório do Flutter:
```
git clone https://github.com/flutter/flutter.git -b stable
```

Adicione o seguinte no final do seu arquivo ~/.bashrc
```
# flutter
export PATH="$PATH:CAMINHO_DA_PASTA_QUE_VC_CLONOU_O_FLUTTER/flutter/bin"
```

Execute:
```
flutter precache
flutter doctor --android-licenses
flutter doctor
```


## Instalar dependências
```
flutter pub get
```

## Executar aplicação
```
flutter clean
flutter run --release
```

# Tarefas

- [X] Login empregado (Aleph)
- [X] Bater ponto (Gabriel)
- [X] Listar pontos (Gabriel)
- [X] Pedir abono (Daniel)
- [X] Exibir banco de horas (Daniel)
- [ ] Lembrete de ponto
