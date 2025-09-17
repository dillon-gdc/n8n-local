# Shared Files Directory

This directory is mounted in your n8n container and accessible to all workflows.

## 📁 What This Is For

- **File storage**: Store files that your workflows can read/write
- **Data exchange**: Share data between different workflows
- **Templates**: Store document templates, images, or other assets
- **Exports**: Save workflow outputs like reports, CSV files, etc.

## 🔧 How to Use in Workflows

Your workflows can access files in this directory using the path `/files/`

### Examples:

**Read a file:**
```javascript
// In a Code node
const fs = require('fs');
const content = fs.readFileSync('/files/template.txt', 'utf8');
return [{ json: { content } }];
```

**Write a file:**
```javascript
// In a Code node  
const fs = require('fs');
const data = "Hello from n8n!";
fs.writeFileSync('/files/output.txt', data);
return [{ json: { message: 'File saved!' } }];
```

**Using the File System nodes:**
- **Read Binary File**: Set path to `/files/yourfile.pdf`
- **Write Binary File**: Set path to `/files/output.csv`

## 📄 File Organization

Organize your files in subdirectories:

```
shared-files/
├── templates/          # Document templates
├── exports/           # Workflow outputs  
├── uploads/           # Files to process
├── images/            # Images and media
└── data/             # CSV, JSON data files
```

## 🔒 Security Note

- Files in this directory are accessible to ALL workflows
- Don't store sensitive credentials here
- Use n8n's credential system for API keys and passwords

## 💡 Tips

- Use descriptive filenames with timestamps: `report_2024-01-15.csv`
- Create subdirectories for different types of files
- Clean up old files periodically to save disk space
- Test file operations with small files first

---

Happy automating! 🚀
