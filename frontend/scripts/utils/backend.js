import { Socket } from '../static/phoenix';

const backend = function() {
  const socket = new Socket("ws://backend:4000/socket", {params: {userToken: "123"}});

  socket.connect();

  const channel = socket.channel('room:lobby', {});
  
  channel.join().receive('ok', function(q){console.log('aok')}).receive('error',function(q){console.log('bad')});

  const sendMessage = function(){
    console.log('wanna send a message');
    channel.push('message', { body: 'some-lovely-text' });
  }
  
  return {
    sendMessage
  }
}

export default backend();