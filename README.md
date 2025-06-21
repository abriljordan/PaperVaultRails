# PaperVault - Google Drive Clone

A modern, feature-rich Google Drive clone built with Ruby on Rails 8, featuring a beautiful UI with Tailwind CSS and comprehensive file management capabilities.

## 🚀 Features

### Core Functionality
- **File Upload & Storage**: Upload files up to 100MB with automatic file type detection
- **Folder Organization**: Create nested folders with unlimited depth
- **File Sharing**: Share files and folders with other users with view/edit permissions
- **Search**: Full-text search across files and folders
- **Starring**: Star important files and folders for quick access
- **Storage Management**: Track storage usage with 5GB free tier

### User Experience
- **Modern UI**: Clean, responsive design inspired by Google Drive
- **Real-time Updates**: Live storage usage and file statistics
- **Bulk Operations**: Upload multiple files at once
- **File Preview**: Automatic file type detection with appropriate icons
- **Breadcrumb Navigation**: Easy folder navigation
- **Mobile Responsive**: Works perfectly on all devices

### Security & Permissions
- **User Authentication**: Secure login with Devise
- **Access Control**: Granular permissions for shared content
- **File Validation**: Type and size restrictions
- **Secure Downloads**: Protected file access

## 🛠 Technology Stack

- **Backend**: Ruby on Rails 8.0.2
- **Database**: PostgreSQL
- **Authentication**: Devise
- **File Storage**: Active Storage (local/S3)
- **Frontend**: Tailwind CSS, Font Awesome
- **JavaScript**: Stimulus, Turbo
- **Icons**: Font Awesome 6.4.0

## 📦 Installation

### Prerequisites
- Ruby 3.4+
- PostgreSQL
- Node.js (for asset compilation)

### Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd PaperVaultRails
   ```

2. **Install dependencies**
   ```bash
   bundle install
   npm install
   ```

3. **Database setup**
   ```bash
   bin/rails db:create
   bin/rails db:migrate
   ```

4. **Start the server**
   ```bash
   bin/dev
   ```

5. **Visit the application**
   ```
   http://localhost:3000
   ```

## 🗂 Database Schema

### Core Models

#### User
- Email, password, name
- Storage usage tracking
- Relationships to folders and documents

#### Folder
- Name, parent folder (tree structure)
- User ownership
- Color customization
- Starring functionality

#### Document
- File attachment via Active Storage
- File type detection
- Size tracking
- Access statistics

#### Sharing Models
- `FolderShare`: Share folders with users
- `DocumentShare`: Share individual documents
- Permission levels (view/edit)

## 🎨 UI Components

### Layout
- **Header**: Logo, search bar, user menu, storage indicator
- **Sidebar**: Navigation menu, quick actions, storage info
- **Main Content**: Dynamic content area with responsive grid

### Design System
- **Colors**: Blue primary (#4285f4), consistent with Google Drive
- **Typography**: Clean, readable fonts
- **Icons**: Font Awesome for consistent iconography
- **Spacing**: Tailwind's spacing system for consistency

## 🔧 Configuration

### Environment Variables
```bash
# Database
DATABASE_URL=postgresql://localhost/papervault_development

# File Storage (optional)
AWS_ACCESS_KEY_ID=your_key
AWS_SECRET_ACCESS_KEY=your_secret
AWS_REGION=us-east-1
AWS_BUCKET=your_bucket
```

### Storage Configuration
By default, files are stored locally. To use S3:

1. Add AWS credentials to your environment
2. Update `config/storage.yml` to use S3
3. Set `Rails.application.config.active_storage.service = :amazon`

## 🚀 Deployment

### Using Kamal (recommended)
```bash
kamal setup
kamal deploy
```

### Manual Deployment
1. Set up your production environment
2. Run database migrations
3. Precompile assets
4. Start the application server

## 📱 PWA Features

The application includes Progressive Web App capabilities:
- Installable on mobile devices
- Offline support (basic)
- App-like experience

## �� Security Features

- CSRF protection
- SQL injection prevention
- File type validation
- Size limits enforcement
- Secure file downloads
- User authentication and authorization

## 🧪 Testing

```bash
# Run all tests
bin/rails test

# Run specific test files
bin/rails test test/models/user_test.rb
```

## 📈 Performance

- Database indexing for fast queries
- Efficient file storage with Active Storage
- Optimized asset delivery
- Responsive design for all screen sizes

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Inspired by Google Drive's design and functionality
- Built with modern Rails best practices
- Uses Tailwind CSS for beautiful, responsive design

---

**PaperVault** - Your secure cloud storage solution built with Rails 8
