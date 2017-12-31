export function needValidation(element, target) {
  if (element.dataset.franktNoValidate !== undefined) return false;
  return target.nodeName === "FORM" && !target.checkValidity();
}

export function serializeElement(element) {
  const data = {};

  if (element) {
    data[element.name] = element.value
  } else {
    console.log('Element not found', element);
  }

  return data;
}
