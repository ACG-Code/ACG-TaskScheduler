# TM1 Job Scheduler

A cube-based job scheduling system for IBM Planning Analytics (TM1) that provides dependency management, multiple schedule types, and visual status tracking.

![TM1](https://img.shields.io/badge/TM1-Planning%20Analytics-blue)
![License](https://img.shields.io/badge/license-MIT-green)

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Process Reference](#process-reference)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)

## Overview

The TM1 Job Scheduler allows administrators to define groups of TI processes (jobs) with individual tasks that can be scheduled to run on various frequencies. Tasks can have dependencies on other tasks, ensuring proper execution order across complex data pipelines.

### Why Use This?

- **Native TM1** - No external tools required, everything runs within Planning Analytics
- **Dependency Management** - Tasks wait for prerequisites to complete before running
- **Visual Monitoring** - Emoji status indicators make it easy to spot issues
- **Flexible Scheduling** - Daily, weekly, monthly, or specific date schedules
- **Self-Healing** - Automatic retry and next-run calculation

## Features

| Feature | Description |
|---------|-------------|
| **Multiple Schedule Types** | Daily, Weekly, Monthly, and Specific date scheduling |
| **Dependency Chains** | Sequential task execution with cross-job dependencies |
| **Dependency Modes** | SameDay, LastRun, and SameCycle validation options |
| **Visual Status Tracking** | Emoji indicators: ✅ ❌ ⏳ 🔄 ⏸ 🚫 |
| **Active/Inactive Control** | Enable or disable jobs and tasks independently |
| **Manual Override** | Force execution or skip dependencies when needed |
| **Circular Dependency Detection** | Prevents infinite loops in dependency chains |

## Architecture

### Data Objects

```
┌─────────────────────────────────────────────────────────────┐
│                  System - Job Scheduler                      │
│                         (Cube)                               │
├─────────────────────────────────────────────────────────────┤
│  Dimensions:                                                 │
│  • System - Scheduled Jobs (Jobs & Tasks)                   │
│  • mSystem - Job Scheduler (Measures)                       │
└─────────────────────────────────────────────────────────────┘
```

### Dimension Structure

**System - Scheduled Jobs** (Hierarchical)
```
Daily Maintenance          (Job - Consolidated)
├── Daily Maintenance|Task1    (Task - Leaf)
├── Daily Maintenance|Task2    (Task - Leaf)
└── Daily Maintenance|Task3    (Task - Leaf)

Monthly FX Rates           (Job - Consolidated)
├── Monthly FX Rates|Task1     (Task - Leaf)
└── Monthly FX Rates|Task2     (Task - Leaf)
```

### Attributes

| Attribute | Type | Description |
|-----------|------|-------------|
| Description | String | Job or task description |
| ProcessName | String | TI process to execute (tasks only) |
| Sequence | Numeric | Execution order within job |
| ElementType | String | 'Job' or 'Task' |

### Measures

| Measure | Type | Description |
|---------|------|-------------|
| Active | String | Y/N - Is job/task enabled |
| Schedule Type | String | Daily, Weekly, Monthly, Specific |
| Days of Week | String | 1=Mon, 2=Tue...7=Sun (comma-separated) |
| Days of Month | String | 1-31 (comma-separated) |
| Specific Dates | String | YYYY-MM-DD (comma-separated) |
| Run Time | String | HH:MM in 24-hour format |
| Last Run Date | String | YYYY-MM-DD |
| Last Run Time | String | HH:MM:SS |
| Last Run Status | String | ✅ Success, ❌ Failed |
| Last Run Message | String | Error details if failed |
| Current Status | String | ⏳ Pending, 🔄 Running, ⏸ Waiting, 🚫 Blocked |
| Next Run Date | Numeric | Date formatted as c:yyyy-mm-dd |
| Execute Now | String | Y/N - Force immediate execution |
| Depends On | String | Prerequisite tasks (comma-separated) |
| Dependency Mode | String | SameDay, LastRun, SameCycle |
| Dependency Status | String | Met, Waiting, Blocked, No Dependencies |
| Blocked By | String | Which dependency is blocking |
| Skip Dependencies | String | Y/N - Bypass dependency check |

## Installation

### Prerequisites

- IBM Planning Analytics / TM1 Server
- Admin access to create dimensions, cubes, and processes
- Ability to create and manage Chores

### Step 1: Create TI Processes

Import or create the following TI processes:

| # | Process Name | Purpose |
|---|--------------|---------|
| 1 | System - Scheduler_Check and Execute | Master scheduler (runs via Chore) |
| 2 | System - Scheduler_Check Dependencies | Validates task dependencies |
| 3 | System - Scheduler_Check Circular Dependencies | Detects dependency cycles |
| 4 | System - Scheduler_Execute Task | Executes individual tasks |
| 5 | System - Scheduler_Calculate Next Run | Calculates next scheduled run |
| 6 | System - Scheduler_Initialize Schedule | Recalculates all NextRunDates |
| 7 | System - Scheduler_Create Job | Creates a new job |
| 8 | System - Scheduler_Create Task | Creates a new task |
| 9 | System - Scheduler_Reset Blocked Tasks | Resets failed/blocked tasks |
| 10 | System - Scheduler_Skip Dependencies | Forces task to bypass dependencies |

### Step 2: Create the Chore

Create a Chore to run the scheduler automatically:

| Setting | Value |
|---------|-------|
| Chore Name | System - Scheduler_Master Chore |
| Process | System - Scheduler_Check and Execute |
| Frequency | Every 5-15 minutes |
| Active | Yes |

### Step 3: Initialize

Run `System - Scheduler_Initialize Schedule` to calculate initial NextRunDate values for all active tasks.

## Configuration

### Schedule Types

| Type | Configuration | Example |
|------|---------------|---------|
| **Daily** | Runs every day at Run Time | Run Time = 06:00 |
| **Weekly** | Runs on specified days | Days of Week = 1,3,5 (Mon, Wed, Fri) |
| **Monthly** | Runs on specified days of month | Days of Month = 1,15 |
| **Specific** | Runs on exact dates | Specific Dates = 2026-03-31,2026-06-30 |

### Days of Week Reference

| Day | Value |
|-----|-------|
| Monday | 1 |
| Tuesday | 2 |
| Wednesday | 3 |
| Thursday | 4 |
| Friday | 5 |
| Saturday | 6 |
| Sunday | 7 |

### Dependency Modes

| Mode | Behavior |
|------|----------|
| **SameDay** | Dependency must have run successfully TODAY |
| **LastRun** | Most recent run must be successful (any date) |
| **SameCycle** | Dependency must complete in current scheduling cycle |

## Usage

### Creating a New Job

Run `System - Scheduler_Create Job` with:

| Parameter | Value |
|-----------|-------|
| pJobName | My_New_Job |
| pDescription | Description of the job |
| pActive | Y |

### Creating a New Task

Run `System - Scheduler_Create Task` with:

| Parameter | Required | Description |
|-----------|----------|-------------|
| pJobName | Yes | Parent job name |
| pTaskName | Yes | Task name (without job prefix) |
| pDescription | No | Task description |
| pProcessName | Yes | TI process to execute |
| pSequence | No | Execution order (default: 1) |
| pScheduleType | Yes | Daily, Weekly, Monthly, Specific |
| pRunTime | Yes | HH:MM in 24-hour format |
| pDaysOfWeek | Weekly | 1-7 comma-separated |
| pDaysOfMonth | Monthly | 1-31 comma-separated |
| pSpecificDates | Specific | YYYY-MM-DD comma-separated |
| pDependsOn | No | Prerequisite task element names |
| pDependencyMode | No | SameDay (default), LastRun, SameCycle |
| pActive | No | Y (default) or N |

### Example: Daily Task

```
pJobName = Daily Maintenance
pTaskName = Import GL Data
pProcessName = Load_GL_Data
pScheduleType = Daily
pRunTime = 06:00
pActive = Y
```

### Example: Weekly Task with Dependency

```
pJobName = Weekly Reports
pTaskName = Generate Flash Report
pProcessName = Rpt_Flash_Report
pScheduleType = Weekly
pRunTime = 07:00
pDaysOfWeek = 1
pDependsOn = Daily Maintenance|Calculate KPIs
pDependencyMode = SameDay
```

### Manual Overrides

**Run Immediately:**
Set `Execute Now = Y` for the task

**Skip Dependencies:**
Run `System - Scheduler_Skip Dependencies` with `pTask = JobName|TaskName`

**Reset Failed/Blocked Tasks:**
Run `System - Scheduler_Reset Blocked Tasks` with `pTask = JobName|TaskName` (or blank for all)

## Process Reference

### Execution Flow

```
┌─────────────────────────┐
│        CHORE            │  Every 5-15 minutes
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│ Check and Execute       │  Master scheduler loop
└───────────┬─────────────┘
            │
    ┌───────┴───────┐
    ▼               ▼
┌─────────┐   ┌─────────────┐
│ Check   │   │ Execute     │
│ Deps    │   │ Task        │
└────┬────┘   └──────┬──────┘
     │               │
     ▼               ▼
┌─────────┐   ┌─────────────┐
│ Check   │   │ Calculate   │
│ Circular│   │ Next Run    │
└─────────┘   └─────────────┘
```

### Process Categories

| Category | Process | Called By |
|----------|---------|-----------|
| Runtime | Check and Execute | Chore (automatic) |
| Runtime | Check Dependencies | Check and Execute |
| Runtime | Check Circular Dependencies | Check Dependencies |
| Runtime | Execute Task | Check and Execute |
| Runtime | Calculate Next Run | Execute Task, Initialize Schedule |
| User Action | Initialize Schedule | Manual |
| User Action | Create Job | Manual |
| User Action | Create Task | Manual |
| User Action | Reset Blocked Tasks | Manual |
| User Action | Skip Dependencies | Manual |

### When to Run Initialize Schedule

| Scenario | Run It? |
|----------|---------|
| After initial setup | ✅ Yes |
| After changing Schedule Type | ✅ Yes |
| After changing Run Time | ✅ Yes |
| After changing Days of Week/Month | ✅ Yes |
| After changing Specific Dates | ✅ Yes |
| After a task runs normally | ❌ No (automatic) |
| After using Create Task | ❌ No (automatic) |
| After changing Active flag | ❌ No |
| After changing Dependencies | ❌ No |

## Status Icons

| Icon | Status | Description |
|------|--------|-------------|
| ✅ | Success | Task completed successfully |
| ❌ | Failed | Task encountered an error |
| ⏳ | Pending | Scheduled and waiting for run time |
| 🔄 | Running | Currently executing |
| ⏸ | Waiting | Run time reached but waiting on dependencies |
| 🚫 | Blocked | Dependency failed, cannot run |

## Troubleshooting

### Task Not Running

| Check | Solution |
|-------|----------|
| Is the Job active? | Set Job Active = Y |
| Is the Task active? | Set Task Active = Y |
| Is Next Run Date set correctly? | Run Initialize Schedule |
| Has the run time passed? | Wait or set Execute Now = Y |
| Are dependencies met? | Check Dependency Status column |
| Is the Chore running? | Verify Chore is active |

### Task Shows Blocked

1. Check the `Blocked By` column to identify failed dependency
2. Fix the failed dependency task
3. Run `Reset Blocked Tasks` for both tasks

### Task Stuck on Running

1. The target process may have failed without proper cleanup
2. Run `Reset Blocked Tasks` with the task name
3. Check TM1 server logs for errors

### Circular Dependency Detected

1. Check the `Blocked By` column for cycle path
2. Remove or modify dependencies to break the cycle
3. A task cannot depend on itself or on tasks that depend on it

## File Structure

```
├── Dimensions/
│   ├── System - Scheduled Jobs.dim
│   └── mSystem - Job Scheduler.dim
├── Cubes/
│   └── System - Job Scheduler.cub
├── Processes/
│   ├── System - Scheduler_Check and Execute.pro
│   ├── System - Scheduler_Check Dependencies.pro
│   ├── System - Scheduler_Check Circular Dependencies.pro
│   ├── System - Scheduler_Execute Task.pro
│   ├── System - Scheduler_Calculate Next Run.pro
│   ├── System - Scheduler_Initialize Schedule.pro
│   ├── System - Scheduler_Create Job.pro
│   ├── System - Scheduler_Create Task.pro
│   ├── System - Scheduler_Reset Blocked Tasks.pro
│   └── System - Scheduler_Skip Dependencies.pro
└── README.md
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Built for IBM Planning Analytics / TM1
- Inspired by enterprise job scheduling systems
- Developed by ACGI

---

**Note:** This scheduler is designed to work within the TM1 environment. For external scheduling needs, consider using the TM1 REST API in conjunction with external scheduling tools.