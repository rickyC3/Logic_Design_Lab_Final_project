# FPGA Dragon Shooter

### NTHU Logic Design Laboratory — Final Project

A Verilog-based FPGA game implemented as the final project for the **Logic Design Laboratory** course at National Tsing Hua University (NTHU).

The project implements a simple 2D shooting game on an FPGA board. The player controls a robot using a PS/2 keyboard and shoots missiles at randomly moving dragons. The game integrates VGA graphics, keyboard input, collision detection, finite-state machines, timers, score tracking, seven-segment display, and audio output.\

---

## Features

* 🎮 **PS/2 keyboard control**

  * `W` / `A` / `S` / `D` — Move the robot
  * `Space` — Fire a missile
* 🐉 **Three independently moving dragons**

  * Each dragon has a different LFSR initialization value
  * Dragons move pseudo-randomly
  * Dragons disappear temporarily after being hit
* 🚀 **Missile system**

  * Missile follows the robot before firing
  * Missile moves horizontally after launch
  * Includes a reload / cooldown mechanism
* 💥 **Collision detection**

  * Detects collisions between the robot, missiles, and dragons
  * Successfully hitting dragons increases the score
* ❤️ **Player death and rounds**

  * Collision with a dragon causes the player to die
  * The number of rounds is updated after the player dies
* 🖥️ **VGA output**

  * 640 × 480 game display
  * Background, robot, dragons, and missiles are rendered using memory initialization files
* 🔢 **Score display**

  * Current score
  * Highest score
  * Current round
  * Displayed through seven-segment displays
* 🔊 **Audio output**

  * Buzzer / speaker output for game events and shooting
* ⏸️ **Pause support**

  * Game movement can be paused and resumed

---

## System Overview

The top-level module is `Top.v`, which integrates the major components of the game.

```text
                       +----------------------+
                       |      PS/2 Keyboard   |
                       +----------+-----------+
                                  |
                                  v
                       +----------------------+
                       |   Keyboard Controller|
                       +----------+-----------+
                                  |
                             Move / Shoot
                                  |
                                  v
+-------------+          +----------------------+
| Clock /     |--------->|      Top.v           |
| Clock Div.  |          |                      |
+-------------+          |  Game Control        |
                         |  Score / Round       |
                         |  Collision Events    |
                         +----+----+----+-------+
                              |    |    |
                 +------------+    |    +-------------+
                 |                 |                  |
                 v                 v                  v
          +------------+    +------------+    +-------------+
          | Robot      |    | Missile    |    |  Dragons    |
          | Movement   |    | Movement   |    | x3          |
          +------------+    +------------+    +-------------+
                 \              |                  /
                  \             |                 /
                   +------------+----------------+
                                |
                                v
                       +----------------------+
                       |     Memory / VGA     |
                       |    Pixel Generator   |
                       +----------+-----------+
                                  |
                                  v
                           640 x 480 VGA

             +----------------+       +----------------+
             | Seven Segment  |       | Buzzer / Audio |
             +----------------+       +----------------+
```

The top-level design instantiates three `Dragon_move` modules, one `Robot_move` module, one `Missile_move` module, the VGA controller, memory generator, keyboard controller, speaker, and score / seven-segment display logic.

---

## Game Mechanics

### Robot

The player controls the robot using the PS/2 keyboard.

| Key     | Action       |
| ------- | ------------ |
| `W`     | Move up      |
| `A`     | Move left    |
| `S`     | Move down    |
| `D`     | Move right   |
| `Space` | Fire missile |

The robot position is continuously updated according to the decoded keyboard input.

---

### Dragons

There are **three dragons** in the game.

Each dragon uses an LFSR-based pseudo-random sequence to determine its movement and respawn position. Different initialization values are used for the three dragons, resulting in different movement patterns.

When a dragon is hit, it enters a temporary dead state and is subsequently respawned at a new pseudo-random position.

---

### Missile

The missile has three main states:

```text
READY
  |
  | Space
  v
FIRING
  |
  | Reach boundary
  v
RELOAD / COOLDOWN
  |
  | Cooldown complete
  v
READY
```

The missile follows the robot while it is in the ready state. After firing, it travels toward the right side of the screen.

A cooldown period is enforced after each shot to prevent continuous firing.

---

### Collision and Scoring

Collision events are generated by the memory / pixel generation logic.

The score is determined by the number of dragons hit during an event:

| Dragons hit | Score |
| ----------- | ----- |
| 1           | +1    |
| 2           | +2    |
| 3           | +3    |

The project also keeps track of the highest score.

When the robot is hit by a dragon, the current round ends and the round counter is incremented.

---

## Display

The game uses VGA output with a **640 × 480** display area.

The game graphics are stored as memory initialization data and include:

* Background
* Robot
* Dragon sprites
* Missile sprite

The repository also contains the original image assets used to generate the corresponding memory data.

### Sprite Sizes

| Object     | Size      |
| ---------- | --------- |
| Robot      | 40 × 30   |
| Dragon     | 40 × 30   |
| Missile    | 56 × 12   |
| Background | 160 × 120 |

---

## Hardware / Input-Output

The project uses the following FPGA peripherals:

```text
PS/2 Keyboard
      │
      ▼
Keyboard Controller
      │
      ├── Robot movement
      └── Missile firing

FPGA
 │
 ├── VGA ───────────────► Game screen
 │
 ├── Seven-Segment ────► Score / Round information
 │
 ├── LED ──────────────► Game status
 │
 └── Audio Output ─────► Buzzer / Speaker
```

---

## Main Verilog Modules

| Module              | Description                                               |
| ------------------- | --------------------------------------------------------- |
| `Top.v`             | Top-level module integrating the complete game            |
| `Robot_move.v`      | Robot movement and player state                           |
| `Dragon_move.v`     | Dragon movement, death, and respawn                       |
| `Missile_move.v`    | Missile movement and firing cooldown                      |
| `Dragon_mem_gen.v`  | Sprite memory, pixel generation, and collision events     |
| `KeyboardCtrl.v`    | PS/2 keyboard controller                                  |
| `KeyboardDecoder.v` | Keyboard scan-code decoding                               |
| `KeyBoard_Sign.v`   | Converts keyboard input into game control signals         |
| `Ps2Interface.v`    | PS/2 communication interface                              |
| `FSM.v`             | Seven-segment display state machine                       |
| `BCD_ctl.v`         | BCD display control                                       |
| `BCD_up_cnt.v`      | BCD counter                                               |
| `INT2BCD.v`         | Binary integer to BCD conversion                          |
| `LFSR.v`            | Linear-feedback shift register for pseudo-random behavior |
| `Clk_22.v`          | Clock divider for game / VGA clocks                       |
| `Divider.v`         | Additional clock division logic                           |
| `Buzzer.v`          | Audio / buzzer control                                    |
| `Speaker.v`         | Speaker interface                                         |
| `vga_controller.v`  | VGA timing and synchronization                            |
| `ssd_top.v`         | Seven-segment display controller                          |

---

## Repository Structure

```text
.
├── Top.v
├── Final_project.xdc
│
├── Robot_move.v
├── Dragon_move.v
├── Missile_move.v
├── Dragon_mem_gen.v
│
├── KeyboardCtrl.v
├── KeyboardDecoder.v
├── KeyBoard_Sign.v
├── Ps2Interface.v
│
├── FSM.v
├── BCD_ctl.v
├── BCD_up_cnt.v
├── INT2BCD.v
│
├── LFSR.v
├── Clk_22.v
├── Divider.v
│
├── Buzzer.v
├── Speaker.v
│
├── Image/
│   ├── robot_pixel_0.jpg
│   ├── drogan_pixel_0.jpg
│   ├── drogan_pixel_1.jpg
│   ├── drogan_pixel_2.jpg
│   ├── missile_pixel_0.jpg
│   ├── Universe0_Image.png
│   └── Universe1_Image.jpg
│
├── Logic diagram/
│   ├── FSM_*.jpg
│   ├── Timer_*.jpg
│   ├── BTNC_signal_ctl_*.jpg
│   ├── _7SegShow.jpg
│   ├── display_number_to_cnt.jpg
│   ├── robot_move (1).png
│   └── dragon_move (1).png
│
└── BIT/
```

The repository contains both the Verilog source code and design diagrams used during development.

---

## Memory Initialization Files

The sprite and background images are converted into `.coe` files for FPGA memory initialization.

Make sure that the correct `.coe` file is selected for each corresponding memory module.

### Required Image Data

| Object     | COE file                          |
| ---------- | --------------------------------- |
| Robot      | `robot.coe`                       |
| Dragon     | `dragon_pixel_1.coe`              |
| Missile    | `missile_3.coe`                   |
| Background | `Universe0.coe` / `Universe1.coe` |

> **Important:** The image dimensions and corresponding `.coe` files must match the memory configuration used in the Verilog design.

The repository includes the original image assets under `Image/`, including robot, dragon, missile, and background images.

---

## Design Diagrams

The `Logic diagram/` directory contains diagrams documenting important parts of the hardware design, including:

* FSM
* Timer
* Seven-segment display
* Robot movement
* Dragon movement
* Button signal control

These diagrams can be used together with the Verilog source code to understand the hardware architecture and state transitions.

---

## Development Environment

The project was developed as a Verilog-based FPGA design for the NTHU Logic Design Laboratory course.

### Main Technologies

* Verilog HDL
* FPGA
* VGA
* PS/2 Keyboard
* Seven-Segment Display
* LFSR
* Finite State Machine (FSM)
* Block RAM / Memory Initialization
* Audio Output

---

## Notes

When downloading or recreating the project, pay particular attention to:

1. Correct `.coe` files
2. Correct image dimensions
3. Memory initialization settings
4. FPGA pin assignments in `Final_project.xdc`
5. VGA timing configuration
6. PS/2 keyboard connections

The files `tmp.v`, `tmp.txt`, and `empty.txt` are empty placeholder files and are not required for the game logic.

---

## Project Goal

This project demonstrates how a relatively complete interactive system can be constructed from basic digital logic components using Verilog HDL.

The main focus is the integration of:

**Input → Control Logic → Game State → Collision Detection → Memory / Graphics → VGA / Audio / Display**

rather than implementing the game using a software processor.

---

## Author

NTHU EE 112061105 陳睿倬 

**NTHU Logic Design Laboratory Final Project**

(README.md is generated by GPT)

Repository:
`rickyC3/Logic_Design_Lab_Final_project`
