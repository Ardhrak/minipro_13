# CSV File Format Guide

This guide explains the CSV formats required for uploading data to the exam seating system.

## 📋 Required CSV Files

### 1. Students CSV (`students.csv`)

**Format:** RegisterNumber, Name, Department, Email, Phone, SubjectCode, ExamDate

**Example:**
```csv
RegisterNumber,Name,Department,Email,Phone,SubjectCode,ExamDate
23B001,John Doe,CSE,john@gecskp.ac.in,9876543210,CS301,2026-03-15
23B002,Jane Smith,ECE,jane@gecskp.ac.in,9876543211,CS301,2026-03-15
23B003,Bob Johnson,MECH,bob@gecskp.ac.in,9876543212,PH201,2026-03-15
23B004,Alice Williams,CSE,alice@gecskp.ac.in,9876543213,CS301,2026-03-15
23B005,Charlie Brown,ECE,charlie@gecskp.ac.in,9876543214,PH201,2026-03-15
```

**Notes:**
- RegisterNumber: Student's unique register number (e.g., 23B001)
- SubjectCode: The exam subject code (e.g., CS301)
- ExamDate: Date in YYYY-MM-DD format (e.g., 2026-03-15)
- Each row represents a student registered for a specific exam

---

### 2. Halls CSV (`halls.csv`)

**Format:** HallCode, HallName, Block, Capacity, Rows, Columns

**Example:**
```csv
HallCode,HallName,Block,Capacity,Rows,Columns
H1,Main Hall A,Block 1,120,10,12
H2,Main Hall B,Block 2,150,10,15
H3,Seminar Hall,Block 1,100,10,10
H4,Lab Hall,Block 3,80,8,10
```

**Notes:**
- HallCode: Unique identifier for the hall (e.g., H1)
- Capacity: Maximum number of students (should equal Rows × Columns)
- Rows: Number of rows in the hall
- Columns: Number of columns/seats per row

---

### 3. Invigilators CSV (`invigilators.csv`)

**Format:** EmployeeId, Name, Department, Email

**Example:**
```csv
EmployeeId,Name,Department,Email
EMP001,Dr. Smith,CSE,smith@gecskp.ac.in
EMP002,Dr. Jones,ECE,jones@gecskp.ac.in
EMP003,Dr. Brown,MECH,brown@gecskp.ac.in
EMP004,Dr. Taylor,CSE,taylor@gecskp.ac.in
```

**Notes:**
- EmployeeId: Unique identifier for invigilator
- Department: Invigilator's department
- Email: Must be valid email address

---

## 🎯 Upload Process

1. **Upload Students** → Upload `students.csv` from "Upload Data" tab
2. **Upload Halls** → Upload `halls.csv`
3. **Upload Invigilators** → Upload `invigilators.csv`
4. **Generate Seating** → Click "Generate Seating Arrangement" and select exam date

## ✅ Data Validation

The system validates:
- CSV file has header row
- All required columns are present
- Data types are correct (numbers for capacity, valid dates, etc.)
- No duplicate register numbers

## 🔄 How It Works

### Admin Flow:
1. Upload CSV files → Data stored in Firestore
2. Generate seating → Algorithm allocates seats
3. Students notified → Seat details visible in student UI

### Student Flow:
1. Login → Dashboard
2. Click "Seat Allocation"
3. View exam details with:
   - Hall name and location
   - Seat code (e.g., A1, B3)
   - Row and column numbers
   - Exam date and time

## 📊 Firestore Collections Created

After upload, data is stored in:
- `students/{registerNumber}` - Student details
- `halls/{hallCode}` - Hall information
- `invigilators/{employeeId}` - Invigilator details
- `exams/{subjectCode}/registrations/` - Student exam registrations
- `students/{registerNumber}/seatAllocations/` - Seat assignments (after generation)

## 🚨 Common Issues

**Issue:** "CSV file is empty or invalid"
- **Solution:** Ensure file has header row and at least one data row

**Issue:** "Error parsing CSV"
- **Solution:** Check all commas are present, no missing columns

**Issue:** "No students registered for this date"
- **Solution:** Verify ExamDate in students.csv matches the date selected for generation

---

## 📝 Sample Data for Testing

Use the examples above to create test CSV files. You can copy them into Excel or a text editor and save as `.csv` format.

For a complete college with 500+ students, you would have multiple rows in students.csv with various:
- Register numbers (23B001 - 23B500)
- Different departments (CSE, ECE, MECH, CIVIL, etc.)
- Multiple subject codes (CS301, PH201, MA101, etc.)
- Same or different exam dates

The system handles large datasets efficiently using batch operations.

