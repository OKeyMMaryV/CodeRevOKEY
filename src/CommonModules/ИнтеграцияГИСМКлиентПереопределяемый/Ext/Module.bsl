﻿////////////////////////////////////////////////////////////////////////////////
//
// ИнтеграцияГИСМКлиент : переопределяемые клиентские процедуры и функции подсистемы "Интеграция с ГИСМ".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открывает форму создания нового контрагента
//
// Параметры:
//   ДанныеКонтрагента - Структура - Содержит поля для заполнения данных нового контрагента.
//   Форма             - УправляемаяФорма - форма-владелец.
//
Процедура ОткрытьФормуСозданияНовогоКонтрагента(ДанныеКонтрагента, Форма) Экспорт
	
	ЗначенияЗаполнения = Новый Структура("НаименованиеПолное, Наименование, ИНН, КПП");
	
	Если ДанныеКонтрагента <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ЗначенияЗаполнения, ДанныеКонтрагента);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ЗначенияЗаполнения.ИНН)
		И СтрДлина(ЗначенияЗаполнения.ИНН) = 12 Тогда
		ЗначенияЗаполнения.Вставить("ЮридическоеФизическоеЛицо",
			ПредопределенноеЗначение("Перечисление.ЮридическоеФизическоеЛицо.ФизическоеЛицо"));
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	ПараметрыФормы.Вставить("ТекстЗаполнения", ЗначенияЗаполнения.Наименование);
	ПараметрыФормы.Вставить("РежимВыбора",        Истина);
	
	ОткрытьФорму("Справочник.Контрагенты.Форма.ФормаЭлемента", ПараметрыФормы, Форма);
	
КонецПроцедуры

// Обработчик выбора нового контрагента
//
// Параметры:
//   ВыбранноеЗначение - Стандартный параметр обработчика формы ОбработкаВыбора
//   ИсточникВыбора    - Стандартный параметр обработчика формы ОбработкаВыбора
//   Объект            - ДокументОбъект - Документ, в форме которого обрабатывается выбор.
//
Процедура ОбработатьВыборНовогоКонтрагента(ВыбранноеЗначение, ИсточникВыбора, Объект) Экспорт
	
	Если ИсточникВыбора.ИмяФормы = "Справочник.Контрагенты.Форма.ФормаЭлемента" Тогда
		Объект.Контрагент = ВыбранноеЗначение;
	КонецЕсли;
	
КонецПроцедуры

// Возвращает через параметр структуру параметров, необходимых для передачи в форму списка документов
// Отчеты о розничных продажах.
//
// Параметры:
//   Параметры - Структура - поля структуры
//		ИмяФормы - Полный путь к форме списка отчетов о розничных продажах
//		ОткрытьРаспоряжения - Булево, нужно ли открывать закладку Распоряжения на форме, если есть
//		ИмяПоляОтветственный - Имя реквизита формы, соответствующего фильтру по ответственному
//		ИмяПоляОрганизация - Имя реквизита формы, соответствующего фильтру по организации.
//
Процедура ПараметрыОткрытияСпискаОтчетыОРозничныхПродажах(Параметры) Экспорт
	
	Параметры = ИнтеграцияГИСМКлиентБП.ПараметрыОткрытияСпискаОтчетыОРозничныхПродажах();
	
КонецПроцедуры

// Возвращает через параметр структуру параметров, необходимых для передачи в форму списка документов
// Возвраты товаров от розничных клиентов.
//
// Параметры:
//   Параметры - Структура - поля структуры
//		ИмяФормы - Полный путь к форме списка отчетов о розничных продажах
//		ДальнейшееДействиеГИСМ - ПредопределенноеЗначение("Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанные")
//		ОткрытьРаспоряжения - Булево, нужно ли открывать закладку Распоряжения на форме, если есть
//		ИмяПоляОтветственный - Имя реквизита формы, соответствующего фильтру по ответственному
//		ИмяПоляОрганизация - Имя реквизита формы, соответствующего фильтру по организации.
//
Процедура ПараметрыОткрытияСпискаВозвратыТоваровОтРозничныхКлиентов(Параметры) Экспорт
	
	Параметры = ИнтеграцияГИСМКлиентБП.ПараметрыОткрытияСпискаВозвратыТоваровОтРозничныхКлиентов();
	
КонецПроцедуры

// Обработчик ПриИзменении таблицы ЗаказанныеКиЗ документа ЗаявкаНаВыпускКиЗ
//
// Параметры:
//   Форма                 - УправляемаяФорма - Форма документа ЗаявкаНаВыпускКиЗ
//   КэшированныеЗначения  - Структура -  используется механизмом обработки изменения реквизитов ТЧ
//   Элемент               - Стандартный параметр обработчика таблицы формы ПриИзменении.
//
Процедура ЗаявкаНаВыпускКиЗЗаказанныеКиЗПриИзменении(Форма, КэшированныеЗначения, Элемент) Экспорт
	
	
КонецПроцедуры

// Предоставляет возможность открыть произвольную форму, в которой выведен список документов.
//
// Параметры:
//   СписокДокументов - СписокЗначений - Список документов, которые необходимо показать в форме
//   Заголовок        - Строка - Заголовок формы.
//
Процедура ОткрытьФормуСпискаДокументов(СписокДокументов, Заголовок) Экспорт

	
КонецПроцедуры

// Обработчик ПриИзменении поля НоменклатураКиЗ таблицы Товары 
// 
// Параметры:
//   ТекущаяСтрока - ДанныеФормыЭлементКоллекции - Текущие данные таблицы, в которой изменяется поле
//   КэшированныеЗначения - Структура -  используется механизмом обработки изменения реквизитов ТЧ.
//
Процедура ТоварыУведомлениеОбИмпортеНоменклатураКиЗПриИзменении(ТекущаяСтрока, КэшированныеЗначения) Экспорт
	
	
КонецПроцедуры

// Открывает форму подбора номенклатуры КиЗ
// 
// Параметры:
//   Форма - УправляемаяФорма - Владелец открываемой формы.
//
Процедура ОткрытьПодборЗаказываемыхКиЗ(Форма) Экспорт
	
	
КонецПроцедуры

// Проверяет, что форма является формой подбора товаров в документ
// Используется в обработчике формы ОбработкаВыбора.
// 
// Параметры:
//   ИсточникВыбора - Строка - имя формы источника выбора.
//   Результат      - Булево - Истина, если форма является формой подбора.
//
Процедура ИсточникВыбораЭтоФормаПодбора(ИсточникВыбора, Результат) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#Область Панель1СМаркировка

// Открывает форму списка видов номенклатуры.
//
Процедура ОткрытьФормуСпискаВидыНоменклатуры(ВладелецФормы) Экспорт
	
	
КонецПроцедуры

// Открывает форму списка номенклатуры.
//
Процедура ОткрытьФормуСпискаНоменклатуры(ВладелецФормы) Экспорт
	
	
КонецПроцедуры

// Открывает форму списка классификатора ТНВЭД.
//
Процедура ОткрытьФормуСпискаКлассификатораТНВЭД(ВладелецФормы) Экспорт
	
	
КонецПроцедуры

#КонецОбласти
