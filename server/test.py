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


app=Flask(__name__)
#1. Extract Data From the Website
def extract_data_website(url):
    loader=SeleniumURLLoader([url])
    data=loader.load()
    text=""
    for page in data:
        text +=page.page_content + " "
        return text
#2. Generate a Summary of the Text
def summarize_llama(text):
    text_chunks = split_text_chunks(text)

    llm = LlamaCpp(
    model_path="models/llama-2-7b-chat.Q4_0.gguf",
    n_ctx=8128,
    device="mps",
    n_batch=256,
    n_gpu_layers=32,
    verbose=True,  # Verbose is required to pass to the callback manager
)
    prompt_template = """Write a concise summary of the following text delimited by triple backquotes.
              Return your response in bullet points which covers the key points of the text.
              ```{text}```
              BULLET POINT SUMMARY:
  """

    prompt = PromptTemplate(template=prompt_template, input_variables=["text"])

    docs = [Document(page_content=t) for t in text_chunks]
    chain=load_summarize_chain(llm=llm, chain_type='stuff', verbose=True,prompt=prompt)
    summary = chain.run(docs)
    return summary


def split_text_chunks(text):
    text_splitter=CharacterTextSplitter(separator='\n',
                                        chunk_size=1000,
                                        chunk_overlap=20)
    text_chunks=text_splitter.split_text(text)
    return text_chunks


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
