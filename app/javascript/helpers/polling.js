export const poll = async ({ fn, validate, maxTime=5*60*1000 }) => {
  let timeElapsed = 0

  const executePoll = async (resolve, reject) => {
    const result = await fn()
    const interval = getPollingInterval(timeElapsed)

    if (validate(result)) {
      return resolve(result)
    } else if (maxTime && timeElapsed >= maxTime) {
      return reject(new Error('Exceeded max time'))
    } else {
      setTimeout(executePoll, interval, resolve, reject)
    }

    timeElapsed += interval
  }

  return new Promise(executePoll)
}

const getPollingInterval = currentTime => {
  const MIN_INTERVAL = 1000
  const MAX_INTERVAL = 5000
  const suggestedInterval = currentTime / 4
  const minSuggestedInterval = Math.max(MIN_INTERVAL, suggestedInterval)

  return Math.min(MAX_INTERVAL, minSuggestedInterval)
}
