/// @description mm_evaluate_partial(@MmTree tree, Int max_depth, Int max_ms, @Stack stack)
/// @param @MmTree tree
/// @param  Int max_depth
/// @param  Int max_ms
/// @param  @Stack stack
/**
Expand the partially built minimax tree to the given maximum depth, pausing upon reaching the given number of milliseconds.
The stack is used between calls to this function. This allows non-blocking expansion of a minimax tree.
*/
{
  // Capture parameters
  var tree = argument0,
      max_depth = argument1,
      max_ms = argument2,
      stack = argument3,
      config = argument0[MM_TREE.CONFIGS],
      ruleset = argument0[MM_TREE.RULESET];
  // Stack frame
  var current_stack_frame,
      current_node,
      current_state,
      available_moves,
      current_depth,
      current_node_children,
      current_child_num,
      alpha,
      beta,
      total_weight,
      progress_weight;
  var stackdir = true, // Always start downward
      done = false;
  if (ds_stack_empty(stack)) {
    current_node = tree[MM_TREE.ROOT];
    current_state = script_execute(ruleset[RULESET.SCR_DECODE], tree[MM_TREE.ROOT_PICKLE]);
    available_moves = array_create(0);
    current_depth = max_depth;
    current_node_children = current_node[MM_NODE.CHILDREN];
    current_child_num = 0;
    alpha = undefined;
    beta = undefined;
    total_weight = 0;
    progress_weight = 1;
  } else {
    current_stack_frame = ds_stack_pop(stack);
    current_node = current_stack_frame[MM_STACK_FRAME.NODE];
    current_state = script_execute(ruleset[RULESET.SCR_DECODE], current_stack_frame[MM_STACK_FRAME.STATE_PICKLE]);
    available_moves = current_stack_frame[MM_STACK_FRAME.MOVES];
    current_depth = current_stack_frame[MM_STACK_FRAME.DEPTH];
    current_node_children = current_node[MM_NODE.CHILDREN];
    current_child_num = current_stack_frame[MM_STACK_FRAME.CHILD_NUM];
    alpha = current_stack_frame[MM_STACK_FRAME.ALPHA];
    beta = current_stack_frame[MM_STACK_FRAME.BETA];
    total_weight = current_stack_frame[MM_STACK_FRAME.PROGRESS_TOTAL];
    progress_weight = current_stack_frame[MM_STACK_FRAME.PROGRESS_WEIGHT];
  }
  var 
  // As long as the stack isn't empty and there is time
  var start_time = current_time;
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
          total_weight,
          progress_weight
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
        progress_weight /= array_length_1d(available_moves);
        total_weight += progress_weight*current_child_num;
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
      total_weight = current_stack_frame[MM_STACK_FRAME.PROGRESS_TOTAL];
      progress_weight = current_stack_frame[MM_STACK_FRAME.PROGRESS_WEIGHT];
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
        // Decode state
        current_state = script_execute(ruleset[RULESET.SCR_DECODE], current_stack_frame[MM_STACK_FRAME.STATE_PICKLE]);
        // Schedule to apply the next available move
        current_child_num++;
        // Change direction to downwards
        stackdir = true;
      }
    }
    // Determine if done
    done = ds_stack_empty(stack) && !stackdir;
  } until (done || (stackdir && !ds_stack_empty(stack) && current_time-start_time >= max_ms));
  // Return progress
  if (done) {
    if (!is_undefined(ruleset[RULESET.SCR_CLEANUP])) {
      script_execute(ruleset[RULESET.SCR_CLEANUP], current_state);
    }
    current_state = undefined;
    return 1;
  } else {
    ds_stack_push(stack, MmStackFrame(
      script_execute(ruleset[RULESET.SCR_ENCODE], current_state),
      current_node,
      available_moves,
      current_child_num,
      current_depth,
      alpha,
      beta,
      total_weight,
      progress_weight
    ));
    if (!is_undefined(ruleset[RULESET.SCR_CLEANUP])) {
      script_execute(ruleset[RULESET.SCR_CLEANUP], current_state);
    }
    current_state = undefined;
    return total_weight+progress_weight*current_child_num/max(1, array_length_1d(available_moves));
  }
}
