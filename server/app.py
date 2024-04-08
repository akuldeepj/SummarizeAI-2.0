from flask import Flask, request, jsonify
from transcript import get_transcript

app = Flask(__name__)
#open cors policy
from flask_cors import CORS
CORS(app, resources={r"/api/*": {"origins": "*"}})

@app.route('/api/get_transcript', methods=['POST'])
def api():
    video_id = request.json['video_id']
    return jsonify({'transcript': get_transcript(video_id)})

if __name__ == '__main__':
    app.run(debug=True,host="0.0.0.0",port=8000)