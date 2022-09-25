#include <sys/time.h>
#include <stdint.h>
#include <stdio.h>
#include <stdbool.h>

#include "snowid.h"

typedef struct snow_state {
    bool enabled;
    /**
     * `checkpoint` is last time when an id was generated.
     * If we detect current time is < checkpoint, then
     * clock has moved backward and we refuse to generate
     * the id.
     */
    uint64_t checkpoint;
    uint64_t worker_id;
    uint16_t sequence_id;
} snow_state_t;

/**
 * Global variable to store the state.
 * Client should use some form of mutex if multiple threads are going to access the API's.
 */
static snow_state_t state;

static void worker_id_init(void);
static bool get_current_ts(uint64_t *);

static bool get_current_ts(uint64_t *result)
{
    time_t t;

    t = time(NULL);

    if (t == (time_t)-1) {
        return false;
    }

    *result = (uint64_t)t;

    return true;
}

bool snow_get_id(snow_id_t *dest)
{
    
    if (state.enabled == true) {
        
        uint64_t current_time;
        
        if (get_current_ts(&current_time) == false) {
            return false;
        }

        if (state.checkpoint > current_time) {
            state.enabled = false;
            fprintf(stderr, "Clock is running backwards.");
            return false;
        }
        
        if (state.checkpoint == current_time) {
            state.sequence_id++;
        } else {
            state.sequence_id = 0;
        }

        state.checkpoint = current_time;

        snow_id_t current = {
            .timestamp = state.checkpoint,
            .worker_id = state.worker_id,
            .sequence_id = state.sequence_id
        };

        *dest = current;

        return true;
    }

    return false;
}

void snow_state_dump(void)
{

    return;
}

void snow_init(snow_config_t *config)
{

    if (config == NULL) {
        fprintf(stderr, "snow config is NULL.");
        state.enabled = false;
        return;
    }

    state.enabled = true;
}

void snow_shutdown()
{

}