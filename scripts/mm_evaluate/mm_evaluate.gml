/// @description mm_evaluate(@MmTree tree, Int max_depth)
/// @param @MmTree tree
/// @param  Int max_depth
/**
Fully expand the unbuilt minimax tree to the given maximum depth.
*/
{
  // Capture arguments
  var tree = argument0,
      max_depth = argument1,
      config = argument0[MM_TREE.CONFIGS],
      ruleset = argument0[MM_TREE.RULESET];
  // Fake call stack
  var stack = ds_stack_create(),
      current_node = tree[MM_TREE.ROOT],
      current_state = script_execute(ruleset[RULESET.SCR_DECODE], tree[MM_TREE.ROOT_PICKLE]),
      available_moves = array_create(0),
      current_depth = max_depth,
      current_node_children = current_node[MM_NODE.CHILDREN],
      current_child_num = 0,
      alpha = undefined,
      beta = undefined,
      stackdir = true; // True for downwards, false for upwards
  // As long as the stack isn't empty
  do {
    // Downwards
    if (stackdir) {
      // Determine if final
      var is_final = script_execute(ruleset[RULESET.SCR_IS_FINAL], current_state);
      // If final or max depth reached:
      if (current_depth == 0 || is_final) {
        // Final nodes get interpreted reward
        if (is_final) {
          current_node[@MM_NODE.VALUE] = script_execute(config[MM_CONFIGS.SCR_INTERPRET_RESULT], script_execute(ruleset[RULESET.SCR_PLAYOUT_RESULT], current_state), current_state, config[MM_CONFIGS.ARG_INTERPRET_RESULT]);
        }
        // Non-final nodes get heuristic reward
        else {
          current_node[@MM_NODE.VALUE] = script_execute(config[MM_CONFIGS.SCR_HEURISTIC], current_state, config[MM_CONFIGS.ARG_HEURISTIC]);
        }
        // Set evaluation movement upwards
        stackdir = false;
        // Clean up the current state
        if (!is_undefined(ruleset[RULESET.SCR_CLEANUP])) {
          script_execute(ruleset[RULESET.SCR_CLEANUP], current_state);
        }
        current_state = undefined;
      }
      // Not final and has depth to spare, expand
      else {
        // Generate available moves
        available_moves = script_execute(ruleset[RULESET.SCR_GENERATE_MOVES], current_state);
        // Create a stack frame remembering current state
        ds_stack_push(stack, MmStackFrame(
          script_execute(ruleset[RULESET.SCR_ENCODE], current_state),
          current_node,
          available_moves,
          current_child_num,
          current_depth--,
          alpha,
          beta,
          0,
          0
        ));
        // Apply current move
        script_execute(ruleset[RULESET.SCR_APPLY_MOVE], current_state, available_moves[current_child_num]);
        // Expand first child node
        current_node_children = current_node[MM_NODE.CHILDREN];
        current_node_children[@current_child_num] = MmNode(
          available_moves[current_child_num],
          script_execute(config[MM_CONFIGS.SCR_POLARITY], script_execute(ruleset[RULESET.SCR_CURRENT_PLAYER], current_state, config[MM_CONFIGS.ARG_POLARITY])),
          undefined,
          array_create(0)
        );
        // Focus to current child
        current_node = current_node_children[current_child_num];
        current_child_num = 0;
        alpha = undefined;
        beta = undefined;
      }
    }
    // Upwards
    else {
      // Unpack the stack frame
      var current_stack_frame = ds_stack_pop(stack);
      current_node = current_stack_frame[MM_STACK_FRAME.NODE];
      available_moves = current_stack_frame[MM_STACK_FRAME.MOVES];
      current_depth = current_stack_frame[MM_STACK_FRAME.DEPTH];
      current_node_children = current_node[MM_NODE.CHILDREN];
      current_child_num = current_stack_frame[MM_STACK_FRAME.CHILD_NUM];
      alpha = current_stack_frame[MM_STACK_FRAME.ALPHA];
      beta = current_stack_frame[MM_STACK_FRAME.BETA];
      var current_child = current_node_children[current_child_num],
          ccv = current_child[MM_NODE.VALUE];
      // If it is a max node:
      if (current_node[MM_NODE.POLARITY] > 0) {
        // Update node value and frame alpha
        if (is_undefined(current_node[MM_NODE.VALUE]) || ccv > current_node[MM_NODE.VALUE]) {
          current_node[@MM_NODE.VALUE] = ccv;
        }
        if (is_undefined(alpha) || ccv > alpha) {
          alpha = ccv;
        }
      }
      // If it is a min node:
      else {
        // Update node value and frame beta
        if (is_undefined(current_node[MM_NODE.VALUE]) || ccv < current_node[MM_NODE.VALUE]) {
          current_node[@MM_NODE.VALUE] = ccv;
        }
        if (is_undefined(beta) || ccv < beta) {
          beta = ccv;
        }
      }
      // If alpha-beta cutoff met or no more children
      if ((alpha > beta && !is_undefined(alpha) && !is_undefined(beta)) || current_child_num+1 == array_length_1d(available_moves)) {
        // Keep going up (no code required)
      }
      // Still more to evaluate
      else {
        // Decode the current frame's state
        current_state = script_execute(ruleset[RULESET.SCR_DECODE], current_stack_frame[MM_STACK_FRAME.STATE_PICKLE]);
        // Schedule to apply the next available move
        current_child_num++;
        // Change direction to downwards
        stackdir = true;
      }
    }
  } until (ds_stack_empty(stack) && !stackdir)
  // Clean up
  if (!is_undefined(ruleset[RULESET.SCR_CLEANUP])) {
    script_execute(ruleset[RULESET.SCR_CLEANUP], current_state);
  }
  current_state = undefined;
  ds_stack_destroy(stack);
}
