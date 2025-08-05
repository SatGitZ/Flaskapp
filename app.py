from flask import Flask, request

app = Flask(__name__)

@app.route('/')
def home():
    return "Hello, World!"

@app.route('/add', methods=['GET'])
def add():
    try:
        num1 = request.args.get('num1', type=float)
        num2 = request.args.get('num2', type=float)
        if num1 is None or num2 is None:
            return "Both num1 and num2 parameters are required.", 400
        result = num1 + num2
        return str(result)
    except Exception as e:
        return str(e), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
