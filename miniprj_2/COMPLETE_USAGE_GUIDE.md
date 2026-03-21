# 🎯 Complete Admin Upload & Seating Generation Guide

## Overview
This system allows admins to upload student, hall, and invigilator data via CSV files, then automatically generate seating arrangements that students can view in real-time.

---

## 📋 Step-by-Step Process

### **Phase 1: Upload Data (Admin)**

#### Step 1: Login as Admin
- Email: `admin@test.com`
- Password: `admin1234`

#### Step 2: Navigate to Seating Arrangement
- From Admin Dashboard → Click **"Seating Arrangement"**

#### Step 3: Upload Files
Go to the **"Upload Data"** tab and upload CSV files in order:

##### 3.1 Upload Students
- Click **"Upload File"** under "Student Details"
- Select `sample_students.csv` (or your custom file)
- Format: `RegisterNumber, Name, Department, Email, Phone, SubjectCode, ExamDate`
- Wait for success message: ✓ "Student details uploaded successfully!"

##### 3.2 Upload Halls
- Click **"Upload File"** under "Hall Details"
- Select `sample_halls.csv`
- Format: `HallCode, HallName, Block, Capacity, Rows, Columns`
- Wait for success message: ✓ "Hall details uploaded successfully!"

##### 3.3 Upload Invigilators
- Click **"Upload File"** under "Invigilator List"
- Select `sample_invigilators.csv`
- Format: `EmployeeId, Name, Department, Email`
- Wait for success message: ✓ "Invigilator list uploaded successfully!"

#### Step 4: Verify Upload Status
Check the progress bar at the top shows **"3/3 Completed"**

---

### **Phase 2: Generate Seating (Admin)**

#### Step 5: Generate Arrangement
- Click the green button: **"GENERATE SEATING ARRANGEMENT"**
- Select exam date from calendar (e.g., March 15, 2026)
- Wait for processing (may take a few seconds)
- Success dialog will show:
  - ✓ Seating arrangement generated successfully!
  - 📅 Exam Date: 2026-03-15
  - 🏛️ Halls Used: X halls
  - Students can now view their seat allocations

#### Step 6: View Generated Plan
- Click **"VIEW HALLS"** button or switch to "Hall List" tab
- See all halls with allocated students
- View seat layouts by clicking **"View Layout"** on any hall card

---

### **Phase 3: Student Views Seat (Student)**

#### Step 7: Student Login
- Student logs in with their credentials
- Example: Email from CSV (e.g., `pkd23cs001@gecskp.ac.in`)

#### Step 8: View Seat Allocation
- From Student Dashboard → Click **"Seat Allocation"**
- Student sees their seat details:
  - **Exam Date**: March 15, 2026
  - **Subject**: Mathematics (CS301)
  - **Hall**: Main Hall A
  - **Seat Code**: A1
  - **Row**: 1
  - **Column**: 1
  - **Block**: Block 1
  - ✓ **Status**: Seat Confirmed

---

## 🗂️ Firestore Database Structure

After upload and generation, data is organized as:

```
Firestore
├── students/
│   └── {registerNumber}/
│       ├── registerNumber: "23B001"
│       ├── name: "John Doe"
│       ├── department: "CSE"
│       ├── email: "pkd23cs001@gecskp.ac.in"
│       ├── phone: "9876543210"
│       └── seatAllocations/        ← STUDENT VIEWS THIS
│           └── {examDate}/
│               ├── examDate: "2026-03-15"
│               ├── hallCode: "H1"
│               ├── hallName: "Main Hall A"
│               ├── seatCode: "A1"
│               ├── seatNumber: 1
│               ├── row: 1
│               ├── column: 1
│               ├── block: "Block 1"
│               ├── notified: true
│               └── notifiedAt: timestamp
│
├── halls/
│   └── {hallCode}/
│       ├── hallCode: "H1"
│       ├── hallName: "Main Hall A"
│       ├── block: "Block 1"
│       ├── capacity: 120
│       ├── rows: 10
│       └── columns: 12
│
├── invigilators/
│   └── {employeeId}/
│       ├── employeeId: "EMP001"
│       ├── name: "Dr. Rajesh Kumar"
│       ├── department: "CSE"
│       └── email: "rajesh@gecskp.ac.in"
│
├── exams/
│   └── {subjectCode}/
│       ├── subjectCode: "CS301"
│       ├── examDate: "2026-03-15"
│       └── registrations/
│           └── {auto-id}/
│               ├── registerNumber: "23B001"
│               ├── examDate: "2026-03-15"
│               └── registeredAt: timestamp
│
└── seatingPlans/
    └── {examDate}/
        ├── examDate: "2026-03-15"
        ├── totalStudents: 20
        ├── totalAllocated: 20
        ├── totalHalls: 2
        ├── generatedAt: timestamp
        └── halls/
            └── {hallCode}/
                ├── hallCode: "H1"
                ├── hallName: "Main Hall A"
                ├── capacity: 120
                ├── allocatedSeats: 20
                └── seats/
                    └── {seatCode}/
                        ├── registerNumber: "23B001"
                        ├── seatNumber: 1
                        ├── seatCode: "A1"
                        ├── row: 1
                        ├── column: 1
                        └── ...
```

---

## 🔄 Data Flow Diagram

```
Admin Uploads CSV
       ↓
[students.csv] → Firestore: students/ + exams/{subjectCode}/registrations/
[halls.csv]    → Firestore: halls/
[invigilators.csv] → Firestore: invigilators/
       ↓
Admin Clicks "Generate Seating"
       ↓
SeatingService reads:
  - exams/{subjectCode}/registrations/ (who is registered)
  - halls/ (available halls)
       ↓
Algorithm allocates seats (largest halls first)
       ↓
Writes to Firestore:
  - seatingPlans/{examDate}/halls/{hallCode}/seats/
  - students/{registerNumber}/seatAllocations/{examDate} ← CRITICAL!
       ↓
Student UI reads:
  - students/{registerNumber}/seatAllocations/{examDate}
       ↓
Student sees: Hall, Seat, Row, Column, Date
```

---

## 📊 CSV File Formats

### 1. Students CSV
```csv
RegisterNumber,Name,Department,Email,Phone,SubjectCode,ExamDate
23B001,John Doe,CSE,pkd23cs001@gecskp.ac.in,9876543210,CS301,2026-03-15
```

### 2. Halls CSV
```csv
HallCode,HallName,Block,Capacity,Rows,Columns
H1,Main Hall A,Block 1,120,10,12
```

### 3. Invigilators CSV
```csv
EmployeeId,Name,Department,Email
EMP001,Dr. Rajesh Kumar,CSE,rajesh@gecskp.ac.in
```

---

## ✅ Testing Checklist

- [ ] Upload students CSV successfully
- [ ] Upload halls CSV successfully
- [ ] Upload invigilators CSV successfully
- [ ] Progress bar shows 3/3
- [ ] Generate seating for specific date
- [ ] Success message appears
- [ ] Switch to Hall List tab - see halls
- [ ] Login as student
- [ ] Navigate to Seat Allocation page
- [ ] See seat details with hall, seat code, row, column
- [ ] Verify "Seat Confirmed" status shown

---

## 🚨 Troubleshooting

### Issue: "No students registered for this date"
**Solution:** 
- Check the ExamDate column in students.csv matches the date you selected
- Format must be: YYYY-MM-DD (e.g., 2026-03-15)

### Issue: "CSV file is empty or invalid"
**Solution:**
- Ensure first row is header row
- At least one data row present
- All commas are in place

### Issue: Student sees "No seat allocations yet"
**Solution:**
- Verify admin generated seating for that exam date
- Check student's register number matches CSV upload
- Verify student has exam registration in CSV

### Issue: Upload button doesn't work
**Solution:**
- Make sure file extension is .csv
- File must be accessible (not opened in Excel)
- Close and reopen the file picker

---

## 🎓 For College-Wide Deployment

### Creating CSV Files for 500+ Students:

1. **Export from existing system** (ERP/Database)
2. **Use Excel**:
   - Column A: Register Numbers (23B001 - 23B500)
   - Column B: Names
   - Column C: Departments
   - Column D: Emails (follow pattern: pkd23cs001@gecskp.ac.in)
   - Column E: Phone numbers
   - Column F: Subject Code (CS301, PH201, etc.)
   - Column G: Exam Date (2026-03-15)
3. **Save As** → CSV (Comma delimited)

### Performance Notes:
- System handles 500+ students efficiently
- Batch operations every 500 records
- Average generation time: 5-10 seconds for 500 students
- Real-time updates to student UI

---

## 📧 Support

For issues or questions:
1. Check this guide first
2. Verify CSV format matches examples
3. Check Firestore console for uploaded data
4. Review error messages in app

---

## 🔐 Security Notes

- Only admins can upload data and generate seating
- Students can only view their own seat allocations
- All data stored securely in Firestore
- Register number validation ensures correct student access

---

**System Version:** 2.0  
**Last Updated:** March 2026  
**Compatible with:** Flutter 3.x, Firebase Firestore

