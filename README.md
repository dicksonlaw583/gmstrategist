# GMStrategist: AI Toolkit for GameMaker Studio 2.x

## Overview

GMStrategist is an open-source library that aims to implement common AI algorithms for GameMaker Studio. This facilitates the development of puzzle, board game and other turn-based AIs.

## Currently Supported Algorithms:

- [**MCTS**](https://en.wikipedia.org/wiki/Monte_Carlo_tree_search): A highly configurable and flexible tree-search algorithm capable of general gameplay. This method is best suited for new games without established theory and/or an obvious means of valuation.
- [**Minimax**](https://en.wikipedia.org/wiki/Minimax): The classic heuristic tree-search algorithm. This method is best suited for games with established theory or an obvious means of valuation.

## Requirements

- GameMaker Studio 2.2 and above

## Installation

Search for GMStrategist on the YoYo Marketplace. Install it and export all of its resources into your project.

## Known Issues

- Asynchronous trial play crashes on Runtime 2.2.0.258 due to a bug in asynchronous messages.

## Contributing to GMStrategist

GMStrategist welcomes pull requests for bug fixes and additional general algorithms.

- Clone this repository.
- Open the project in GameMaker Studio and make your additions/changes as a sub-group in the `GMStrategist` group (essential scripts and objects only).
- Export the entire `GMStrategist` group (essential scripts and objects only) to the GMStrategist extension.
- Open a pull request.

In order to ensure general interoperability, please **work in local scope whenever possible**, and minimize all use of instance and global scopes.