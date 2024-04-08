from flask import Flask, jsonify, request
from langchain.document_loaders import SeleniumURLLoader
from langchain.text_splitter import CharacterTextSplitter
from langchain_community.llms.llamacpp import LlamaCpp
from langchain.chains.summarize import load_summarize_chain
from langchain.docstore.document import Document
from urllib.parse import unquote
from langchain import PromptTemplate
from transcript import get_transcript
from gemini_llm import summarize
from llama_llm import summarize_llama, extract_data_website, split_text_chunks

app=Flask(__name__)


@app.route('/', methods=['GET', 'POST'])
def home():
    return "Summary Generator"

@app.route('/summary_generate', methods=['GET', 'POST'])
def summary_generator_url():
    encode_url=unquote(unquote(request.args.get('url')))
    if not encode_url:
        return jsonify({'error':'URL is required'}), 400
    text=extract_data_website(encode_url)
    #text_chunks=split_text_chunks(text)
    #print(len(text_chunks))
    summary=summarize_llama(text)
    # summary=summarize(text)
    print("Here is the Complete Summary", summary)
    response= {
        'submitted_url': encode_url,
        'summary': summary,

    }
    return jsonify(response)

@app.route('/api/get_yt_transcript', methods=['POST'])
@app.route('/api/get_transcript', methods=['POST'])
def yttran():
    link = request.json['link']
    video_id = link
    for i in range(len(video_id)):
        if video_id[i] == "=":
            video_id = video_id[i+1:]
            break
    
    return jsonify({'transcript': get_transcript(video_id)})

@app.route('/api/get_yt_summary', methods=['POST'])
def api():
    link = request.json['link']
    video_id = link
    for i in range(len(video_id)):
        if video_id[i] == "=":
            video_id = video_id[i+1:]
            break
    summary = summarize_llama(get_transcript(video_id))
    # summary = summarize(get_transcript(video_id))
    print(summary)
    return jsonify({'transcript': get_transcript(video_id),
                    'summary': summary,
                    'link': link
                    })


if __name__ == '__main__':
    app.run(debug=True,port=8000)
