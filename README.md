# 🦸 HeroCompare

Aplicativo mobile desenvolvido em **Flutter** para a disciplina de Desenvolvimento Mobile 2026.1 — **ICEV**.

Explore, busque e compare super-heróis do universo Marvel e DC lado a lado, montando seu time dos sonhos.

---

## ✨ Funcionalidades

- 🔍 Busca de heróis por nome em tempo real
- ⚔️ Modo Duelo — compare dois heróis lado a lado
- 🛡️ Monte seu time com até 6 heróis
- 📊 Veja stats detalhados: inteligência, força, velocidade, durabilidade, poder e combate
- 🎭 Filtros por alinhamento (Herói, Vilão, Neutro) e poder mínimo
- 📖 Página de detalhes com biografia, aparência e estatísticas
- 💾 Time salvo localmente — persiste entre sessões

---

## 🛠 Tecnologias

- [Flutter](https://flutter.dev/) + Dart
- [SuperHero API](https://superheroapi.com/)
- [Supabase Flutter](https://supabase.com/docs/reference/dart/introduction)
- [Shared Preferences](https://pub.dev/packages/shared_preferences)
- [HTTP](https://pub.dev/packages/http)

---

## 📁 Estrutura do Projeto

```
lib/
├── config/         # api_conf.dart, supabase_conf.dart
├── models/         # heroes_dto.dart
├── navigation/     # root_navigation.dart
├── pages/          # home, team, login, info_hero, comparison
├── routes/         # app_routes.dart
├── services/       # remote_service, auth_service, supabase_service
├── shared/         # hero_card, app_bar, bottom_nav, filter_button
└── main.dart
```

---

## 🚀 Rodando no Celular Físico

### Pré-requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado
- Android 5.0+ ou iOS 12+
- Cabo USB

### Passo a passo

**1. Clone o repositório**
```bash
git clone https://github.com/guiSanMelo/superhero_compare.git
cd superhero_compare
```

**2. Instale as dependências**
```bash
flutter pub get
```

**3. Ative a Depuração USB no celular (Android)**

- Vá em **Configurações → Sobre o telefone**
- Toque 7 vezes no **Número da compilação** até aparecer _"Você é um desenvolvedor!"_
- Volte e acesse **Opções do desenvolvedor**
- Ative **Depuração USB**
- Conecte o celular via cabo USB e, quando aparecer a mensagem no celular, toque em **Permitir**

**4. Verifique se o dispositivo foi reconhecido**
```bash
flutter devices
```
Seu celular deve aparecer na lista.

**5. Rode o app**
```bash
flutter run
```

> Para instalar a versão final sem modo debug, use `flutter run --release`

---

## 🖥️ Rodando no Android Studio

### Pré-requisitos

- [Android Studio](https://developer.android.com/studio) instalado
- Plugin **Flutter** e **Dart** instalados no Android Studio
  - Vá em `File → Settings → Plugins`, busque por `Flutter` e instale (o Dart é instalado junto)

### Passo a passo

**1. Abra o projeto**

- No Android Studio, clique em **Open**
- Navegue até a pasta `superhero_compare` e selecione-a

**2. Configure o SDK do Flutter**

- Vá em `File → Settings → Languages & Frameworks → Flutter`
- Informe o caminho do Flutter SDK (ex: `C:\flutter` ou `~/flutter`)

**3. Instale as dependências**

- Abra o terminal integrado (`View → Tool Windows → Terminal`) e rode:
```bash
flutter pub get
```
Ou clique em **"Pub get"** no banner que aparece no topo do `pubspec.yaml`.

**4. Selecione o dispositivo**

No topo da tela, na barra de ferramentas, clique no seletor de dispositivos (onde aparece _"No device"_) e escolha:
- Um **celular físico** conectado via USB
- Um **emulador Android** (se não tiver um criado, vá em `Device Manager → Create Device`)

**5. Rode o app**

Clique no botão ▶️ **Run** (ou pressione `Shift + F10`).

---

## 📦 Instalando o APK diretamente

Se quiser instalar sem precisar do ambiente de desenvolvimento, o repositório contém um APK pronto:

1. Baixe o arquivo `apk (1).zip` da raiz do repositório
2. Extraia o `.apk`
3. Transfira para o celular e abra o arquivo
4. Caso apareça um aviso de segurança, vá em **Configurações → Instalar apps desconhecidos** e permita a instalação

---

## 👨‍💻 Autores

Projeto acadêmico desenvolvido por:

| Nome |
|---|
| Guilherme Santos de Melo |
| João Antônio Martins de Almeida Alves |
| Laura Maria Madeira Borges Teixeira |
| Romerson Claudino Gonsalves Filho |

**ICEV — Desenvolvimento Mobile 2026.1**
