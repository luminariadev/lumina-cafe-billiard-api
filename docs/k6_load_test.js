import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  vus: 10,  // 10 virtual users
  duration: '30s',
};

export default function () {
  const res = http.get('http://localhost:3000/api/v1/products');
  check(res, { 'status was 200': (r) => r.status == 200 });
  sleep(1);
}
