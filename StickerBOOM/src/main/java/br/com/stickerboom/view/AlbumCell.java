package br.com.stickerboom.view;

import br.com.stickerboom.album.Album;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.control.Label;
import javafx.scene.control.ListCell;
import javafx.scene.layout.HBox;

import java.io.IOException;

public class AlbumCell extends ListCell<Album> {

    @FXML
    private Label titleLabel;

    @FXML
    private Label ISBNLabel;

    @FXML
    private Label numberStickersLabel;

    @FXML
    private HBox pane;

    public AlbumCell() {

        try {
            FXMLLoader loader = new FXMLLoader(getClass().getResource("/br/com/stickerboom/view/album_cell.fxml"));
            loader.setController(this);
            loader.load();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    protected void updateItem(Album album, boolean b) {
        super.updateItem(album, b);
        if (b || album == null) {
            setText(null);
            setGraphic(null);
        } else {
            titleLabel.setText(album.getTitle());
            ISBNLabel.setText(Long.toString(album.getISBN()));
            numberStickersLabel.setText(Integer.toString(album.getStickerNumber()));
            setGraphic(pane);
        }
    }
}
