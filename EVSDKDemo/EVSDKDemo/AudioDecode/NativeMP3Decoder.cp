/*
 * NativeMP3Decoder.cpp
 *
 *  Created on: 2015��2��6��
 *      Author: Administrator
 */


#define TAG "NativeMP3Decoder"


#include "FileSystem.h"

#include "mad.h"
#include "NativeMP3Decoder.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define SHRT_MAX (32767)
#define INPUT_BUFFER_SIZE   (8192/4)
#define OUTPUT_BUFFER_SIZE  8192 /* Must be an integer multiple of 4. */

//int g_size;
extern "C" {
extern int file_open(const char *filename, int flags);
extern int file_read(T_pFILE fd, unsigned char *buf, int size);
extern int file_write(T_pFILE fd, unsigned char *buf, int size);
extern int64_t file_seek(T_pFILE fd, int64_t pos, int whence);
extern int file_close(T_pFILE fd);

/**
 * Struct holding the pointer to a wave file.
 */
typedef struct
{
    int size;
    int64_t fileStartPos;
    T_pFILE file;
    struct mad_stream stream;
    struct mad_frame frame;
    struct mad_synth synth;
    mad_timer_t timer;
    int leftSamples;
    int offset;
    unsigned char inputBuffer[INPUT_BUFFER_SIZE];
} MP3FileHandle;


/** static WaveFileHandle array **/
static inline int readNextFrame( MP3FileHandle* mp3 );

static MP3FileHandle* Handle;
unsigned int g_Samplerate;

/**
 * Seeks a free handle in the handles array and returns its index or -1 if no handle could be found
 */

static inline void closeHandle()
{
    file_close( Handle->file);
    mad_synth_finish(&Handle->synth);
    mad_frame_finish(&Handle->frame);
    mad_stream_finish(&Handle->stream);
    free(Handle);
    Handle = NULL;
}

static inline signed short fixedToShort(mad_fixed_t Fixed)
{
    if(Fixed>=MAD_F_ONE)
        return(SHRT_MAX);
    if(Fixed<=-MAD_F_ONE)
        return(-SHRT_MAX);

    Fixed=Fixed>>(MAD_F_FRACBITS-15);
    return((signed short)Fixed);
}


int  NativeMP3Decoder_init(char const* filepath,unsigned long start/*,unsigned long size*/)
{

    //__android_log_print(ANDROID_LOG_INFO, TAG, "start = %d*******\n",start);

   // __android_log_print(ANDROID_LOG_INFO, TAG, "size = %d*******\n",size);


    //g_size=size;


    T_pFILE fileHandle = file_open( filepath, _FMODE_READ);
    if( fileHandle == 0 )
        return -1;

    MP3FileHandle* mp3Handle = (MP3FileHandle*)malloc(sizeof(MP3FileHandle));
    memset(mp3Handle, 0, sizeof(MP3FileHandle));
    mp3Handle->file = fileHandle;


   // mp3Handle->size = size;
    mp3Handle->fileStartPos= start;

    file_seek( mp3Handle->file, start, SEEK_SET);

    mad_stream_init(&mp3Handle->stream);
    mad_frame_init(&mp3Handle->frame);
    mad_synth_init(&mp3Handle->synth);
    mad_timer_reset(&mp3Handle->timer);

    Handle = mp3Handle;


    readNextFrame( Handle );

    g_Samplerate = Handle->frame.header.samplerate;
    return 1;
}

static inline int readNextFrame( MP3FileHandle* mp3 )
{
    do
    {
        if( mp3->stream.buffer == 0 || mp3->stream.error == MAD_ERROR_BUFLEN )
        {
            int inputBufferSize = 0;

            if( mp3->stream.next_frame != 0 )
            {

                int leftOver = mp3->stream.bufend - mp3->stream.next_frame;
                int i;
                for(  i= 0; i < leftOver; i++ )
                    mp3->inputBuffer[i] = mp3->stream.next_frame[i];
                int readBytes = file_read( mp3->file, mp3->inputBuffer + leftOver, INPUT_BUFFER_SIZE - leftOver);
                if( readBytes == 0 )
                    return 0;
                inputBufferSize = leftOver + readBytes;
            }
            else
            {

                int readBytes = file_read( mp3->file, mp3->inputBuffer, INPUT_BUFFER_SIZE);
                if( readBytes == 0 )
                    return 0;
                inputBufferSize = readBytes;
            }

            mad_stream_buffer( &mp3->stream, mp3->inputBuffer, inputBufferSize );
            mp3->stream.error = MAD_ERROR_NONE;

        }

        if( mad_frame_decode( &mp3->frame, &mp3->stream ) )
        {

            if( mp3->stream.error == MAD_ERROR_BUFLEN ||(MAD_RECOVERABLE(mp3->stream.error)))
                continue;
            else
                return 0;
        }
        else
            break;
    }
    while( 1 );

    mad_timer_add( &mp3->timer, mp3->frame.header.duration );
    mad_synth_frame( &mp3->synth, &mp3->frame );
    mp3->leftSamples = mp3->synth.pcm.length;
    mp3->offset = 0;

    return -1;
}



int NativeMP3Decoder_readSamples(short *target, int size)
{

    MP3FileHandle* mp3 = Handle;
    //short* target = (short*)env->GetDirectBufferAddress(buffer);
    int pos=0;
    int idx = 0;
    while( idx != size )
    {
        if( mp3->leftSamples > 0 )
        {
            for( ; idx < size && mp3->offset < mp3->synth.pcm.length; mp3->leftSamples--, mp3->offset++ )
            {
                int value = fixedToShort(mp3->synth.pcm.samples[0][mp3->offset]);

                if( MAD_NCHANNELS(&mp3->frame.header) == 2 )
                {
                    value += fixedToShort(mp3->synth.pcm.samples[1][mp3->offset]);
                    value /= 2;
                }

                target[idx++] = value;
            }
        }
        else
        {

            pos = file_seek( mp3->file, 0, SEEK_CUR);

            int result = readNextFrame( mp3);
            if( result == 0 )
                return 0;
        }

    }
  /*  if(pos > mp3->fileStartPos + mp3->size)
    {

        __android_log_print(ANDROID_LOG_INFO, TAG, "*****return -1**\n");
        return -1;
    }
*/
    if( idx > size )
        return 0;

    //return size;
    return pos;

}

int NativeMP3Decoder_getAduioSamplerate()
{
    return g_Samplerate;

}


void  NativeMP3Decoder_closeAduioFile()
{
    if( Handle != 0 )
    {
        closeHandle();
        Handle = 0;
    }
}
}
