

Функция ПолучитьТаблицуКоманд()
  Команды = Новый ТаблицаЗначений;
  Команды.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
  Команды.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка"));
  Команды.Колонки.Добавить("Использование", Новый ОписаниеТипов("Строка"));
  Команды.Колонки.Добавить("ПоказыватьОповещение", Новый ОписаниеТипов("Булево"));
  Команды.Колонки.Добавить("Модификатор", Новый ОписаниеТипов("Строка"));
  Возврат Команды;
КонецФункции

Процедура ДобавитьКоманду(ТаблицаКоманд, Представление, Идентификатор, Использование, ПоказыватьОповещение = Ложь, Модификатор = "")
  НоваяКоманда = ТаблицаКоманд.Добавить();
  НоваяКоманда.Представление = Представление;
  НоваяКоманда.Идентификатор = Идентификатор;
  НоваяКоманда.Использование = Использование;
  НоваяКоманда.ПоказыватьОповещение = ПоказыватьОповещение;
  НоваяКоманда.Модификатор = Модификатор;
КонецПроцедуры

Функция СведенияОВнешнейОбработке() Экспорт

    ПараметрыРегистрации = Новый Структура;
    МассивНазначений = Новый Массив;
    МассивНазначений.Добавить("Документ.бит_ФормаВводаБюджета");

    ПараметрыРегистрации.Вставить("Вид","ЗаполнениеОбъекта");
    ПараметрыРегистрации.Вставить("Назначение", МассивНазначений);
    ПараметрыРегистрации.Вставить("Версия", "1.0");
    ПараметрыРегистрации.Вставить("Наименование", "Копирование данных бюджета "+ПараметрыРегистрации.Версия);
    ПараметрыРегистрации.Вставить("БезопасныйРежим", Ложь);
    ПараметрыРегистрации.Вставить("Информация", "Копирование данных бюджета");

    ТаблицаКоманд = ПолучитьТаблицуКоманд();

    ДобавитьКоманду(ТаблицаКоманд,
    "Копирование данных бюджета (БИТ)",
    "Копирование данных бюджета (БИТ)",
    "ОткрытиеФормы",
    Истина);

    ПараметрыРегистрации.Вставить("Команды", ТаблицаКоманд);

    Возврат ПараметрыРегистрации;
КонецФункции


