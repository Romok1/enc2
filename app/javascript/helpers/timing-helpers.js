export const executeAfterCondition = ({conditionCb, successCb, maxAttempts=0, intervalSpacing=200}) => {
  let attempts = 0

  const interval = setInterval(() => {
    attempts++

    if (
      conditionCb() || 
      (maxAttempts && attempts > maxAttempts)
    ) {
      clearInterval(interval)
      successCb()
    }
  }, intervalSpacing)
}