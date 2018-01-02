import serialize from 'form-serialize';

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

export function serializeForm(element) {
  const data = [];
  data.push({csrf_token: document.querySelector('meta[name=csrf]').content});

  if (element.name) {
    data.push(serializeElement(element.name));
  }

  if (element.dataset.franktTarget) {
    const target = document.querySelector(element.dataset.franktTarget);

    // Block submit form on enter
    $(target).on('submit', (e) => {
      e.preventDefault();
    });

    if (needValidation(element, target)) {
      return target.reportValidity();
    }

    data.push(serialize(target, {hash: true}));
  }

  return Object.assign(...data);
}

export function attachEvent(type, selector, handler) {

}
