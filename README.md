# Setka Integration REST API wrapper

Wraps the Setka Integration API for access from ruby applications.

Documentation for the Setka Editor API: https://setka.gitbook.io/help-center/api/setka-editor-api/integration-with-style-manager.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'setka_integration'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install setka_integration

## Usage

### Configuration

First, put in your initializers next script:

```ruby
SetkaIntegration.configure(
  license_key: 'your_license_key'
)
```

You can find instructions about license keys in the [Before you start section](https://setka.gitbook.io/help-center/api/setka-editor-api/integration-with-style-manager#before-you-start) of Setka Editor API documentation.

### Initial sync

To get style and editor files, you have to run

```ruby
SetkaIntegration::Init.files
```

You can find the description of the received files in the following [API request documentation section](https://setka.gitbook.io/help-center/api/setka-editor-api/integration-with-style-manager/initial-sync-receiving-setka-editor-files-to-connect-them-to-your-cms#h_1dfb3c92-7fdf-4a99-9717-80012f124e89). You will receive only files URLs without additional info like *id* and *filetype*.

### Additional files

To make an API request for the additional files:

```ruby
SetkaIntegration::Options.files('amp,fonts,icons')
```

You can customize arguments like `'amp,icons'`, `'fonts'` and other combinations. You can find the description of the received files in the following [API request documentation section](https://setka.gitbook.io/help-center/api/setka-editor-api/integration-with-style-manager/initial-sync-receiving-setka-editor-files-to-connect-them-to-your-cms#description-of-a-received-array-of-files).

### Specific files

To get the needed array of files:

```ruby
SetkaIntegration::Select.files('plugins,editor,theme,standalone,amp,fonts,icons')
```

You can customize arguments. You can find the description of the received files in the following [API request documentation section](https://setka.gitbook.io/help-center/api/setka-editor-api/integration-with-style-manager/initial-sync-receiving-setka-editor-files-to-connect-them-to-your-cms#list-of-available-files).

Also, you have request to receive files for full options list:

```ruby
SetkaIntegration::Select.all
```

And, if you want, you have requests to get single kind of files:

```ruby
SetkaIntegration::Select.public_token
SetkaIntegration::Select.plugins
SetkaIntegration::Select.editor_files
SetkaIntegration::Select.theme_files
SetkaIntegration::Select.standalone_styles
SetkaIntegration::Select.amp_styles
SetkaIntegration::Select.fonts
SetkaIntegration::Select.icons
```
