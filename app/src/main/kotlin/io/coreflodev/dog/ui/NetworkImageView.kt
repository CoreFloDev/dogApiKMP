package io.coreflodev.dog.ui

import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import coil.compose.AsyncImage

@Composable
fun LoadImage(url: String, modifier: Modifier = Modifier) {
    AsyncImage(
        url,
        contentDescription = null,
        modifier = modifier
    )
}
