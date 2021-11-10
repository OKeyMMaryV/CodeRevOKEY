﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Инициализирует набор параметров, задающих флаги выполнения дополнительных действий над сущностями, обрабатываемыми
// в процессе формирования отчета.
//
// Возвращаемое значение:
//   Структура   - флаги, задающие необходимость дополнительных действий.
//
Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИспользоватьПередКомпоновкойМакета", Истина);
	Результат.Вставить("ИспользоватьПослеКомпоновкиМакета",  Истина);
	Результат.Вставить("ИспользоватьПослеВыводаРезультата",  Истина);
	Результат.Вставить("ИспользоватьДанныеРасшифровки",      Истина);

	Возврат Результат;

КонецФункции

// Формирует текст, выводимый в заголовке отчета.
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//
// Возвращаемое значение:
//   Строка      - текст заголовка с учетом периода.
//
Функция ПолучитьТекстЗаголовка(ПараметрыОтчета) Экспорт 
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Сводные проводки%1'"),
		БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода));
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет. Изменения сохранены не будут.
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//  Схема        - СхемаКомпоновкиДанных - описание получаемых данных.
//  КомпоновщикНастроек - КомпоновщикНастроекКомпоновкиДанных - связь настроек компоновки данных и схемы компоновки.
//
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	КомпоновщикНастроек.Настройки.Структура.Очистить();
	КомпоновщикНастроек.Настройки.Выбор.Элементы.Очистить();
	//
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоДня(ПараметрыОтчета.НачалоПериода));
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
	КонецЕсли;
	//
	КоличествоПоказателей = БухгалтерскиеОтчетыВызовСервера.КоличествоПоказателей(ПараметрыОтчета);
	
	// Колонка "СчетДт"
	ГруппаСчетДт = КомпоновщикНастроек.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаСчетДт.Заголовок     = НСтр("ru = 'Счет Дт'");
	ГруппаСчетДт.Использование = Истина;
	ГруппаСчетДт.Расположение  = РасположениеПоляКомпоновкиДанных.Горизонтально;
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаСчетДт, "СчетДт");
	
	// Колонка "СчетКт"
	ГруппаСчетКт = КомпоновщикНастроек.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаСчетКт.Заголовок     = НСтр("ru = 'Счет Кт'");
	ГруппаСчетКт.Использование = Истина;
	ГруппаСчетКт.Расположение  = РасположениеПоляКомпоновкиДанных.Горизонтально;
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаСчетКт, "СчетКт");
	
	// Колонка "Показатели"
	Если КоличествоПоказателей > 1 Тогда
		
		ГруппаПоказатели = КомпоновщикНастроек.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ГруппаПоказатели.Заголовок     = БухгалтерскиеОтчеты.ЗаголовокГруппыПоказателей();
		ГруппаПоказатели.Использование = Истина;
		ГруппаПоказатели.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	
		Для Каждого ИмяПоказателя Из ПараметрыОтчета.НаборПоказателей Цикл
			Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаПоказатели, "Показатели." + ИмяПоказателя);
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	ГруппаДт = КомпоновщикНастроек.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаДт.Заголовок     = НСтр("ru = 'Дебет'");
	ГруппаДт.Использование = Истина;
	ГруппаДт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	ГруппаКт = КомпоновщикНастроек.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаКт.Заголовок     = НСтр("ru = 'Кредит'");
	ГруппаКт.Использование = Истина;
	ГруппаКт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	Для Каждого ИмяПоказателя Из ПараметрыОтчета.НаборПоказателей Цикл
		Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаДт, "ОборотыЗаПериод." + ИмяПоказателя + "ОборотДт");
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаКт, "ОборотыЗаПериод." + ИмяПоказателя + "ОборотКт");
		КонецЕсли;
	КонецЦикла;

	Структура = КомпоновщикНастроек.Настройки.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	Структура.Имя = "Детали";
	Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
	Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
		
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	
	УсловноеОформление = КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы.Добавить();	
	Поле = УсловноеОформление.Поля.Элементы.Добавить();
	Поле.Поле = Новый ПолеКомпоновкиДанных("ОборотыЗаПериод.НУОборотДт");
	Поле = УсловноеОформление.Поля.Элементы.Добавить();
	Поле.Поле = Новый ПолеКомпоновкиДанных("ОборотыЗаПериод.ПРОборотДт");
	Поле = УсловноеОформление.Поля.Элементы.Добавить();
	Поле.Поле = Новый ПолеКомпоновкиДанных("ОборотыЗаПериод.ВРОборотДт");
	
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(УсловноеОформление.Отбор, "ЕстьНалоговыйУчет", 0);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(УсловноеОформление.Оформление, "МаксимальнаяВысота", 1);
	
	УсловноеОформление = КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы.Добавить();	
	Поле = УсловноеОформление.Поля.Элементы.Добавить();
	Поле.Поле = Новый ПолеКомпоновкиДанных("ОборотыЗаПериод.КоличествоОборотДт");
	
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(УсловноеОформление.Отбор, "ЕстьКоличество", 0);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(УсловноеОформление.Оформление, "МаксимальнаяВысота", 1);
	
	УсловноеОформление = КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы.Добавить();	
	Поле = УсловноеОформление.Поля.Элементы.Добавить();
	Поле.Поле = Новый ПолеКомпоновкиДанных("ОборотыЗаПериод.ВалютнаяСуммаОборотДт");
	
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(УсловноеОформление.Отбор, "ЕстьВалюта", 0);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(УсловноеОформление.Оформление, "МаксимальнаяВысота", 1);
	
КонецПроцедуры

// В процедуре можно уточнить особенности вывода данных в отчет.
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//  МакетКомпоновки - МакетКомпоновкиДанных - описание выводимых данных.
//			
Процедура ПослеКомпоновкиМакета(ПараметрыОтчета, МакетКомпоновки) Экспорт
	
	МакетШапкиОтчета = БухгалтерскиеОтчеты.ПолучитьМакетШапки(МакетКомпоновки);
	
	МассивДляУдаления = Новый Массив;
	Для Индекс = 1 По МакетШапкиОтчета.Макет.Количество() - 1 Цикл
		МассивДляУдаления.Добавить(МакетШапкиОтчета.Макет[Индекс]);
	КонецЦикла;
	
	Для Каждого Элемент Из МассивДляУдаления Цикл
		МакетШапкиОтчета.Макет.Удалить(Элемент);
	КонецЦикла;
	
КонецПроцедуры

// В процедуре можно изменить табличный документ после вывода в него данных.
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//  Результат    - ТабличныйДокумент - сформированный отчет.
//
Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);

	Если Результат.Области.Найти("Заголовок") = Неопределено Тогда
		Результат.ФиксацияСверху = 1;
	Иначе
		Результат.ФиксацияСверху = Результат.Области.Заголовок.Низ + 1;
	КонецЕсли;
	
	Индекс = Результат.ВысотаТаблицы;
	Пока Индекс > 0 Цикл
		ИндексСтроки = "R" + Формат(Индекс,"ЧГ=0");
		Если Результат.Область(ИндексСтроки).ВысотаСтроки = 1 Тогда
			Результат.УдалитьОбласть(Результат.Область(ИндексСтроки), ТипСмещенияТабличногоДокумента.ПоВертикали);
		КонецЕсли;
		Индекс = Индекс - 1;
	КонецЦикла;
	
КонецПроцедуры

// Задает набор показателей, которые позволяет анализировать отчет.
//
// Возвращаемое значение:
//   Массив      - основные суммовые показатели отчета.
//
Функция ПолучитьНаборПоказателей() Экспорт
	
	НаборПоказателей = Новый Массив;
	НаборПоказателей.Добавить("БУ");
	НаборПоказателей.Добавить("НУ");
	НаборПоказателей.Добавить("ПР");
	НаборПоказателей.Добавить("ВР");
	НаборПоказателей.Добавить("ВалютнаяСумма");
	НаборПоказателей.Добавить("Количество");
	
	Возврат НаборПоказателей;
	
КонецФункции

#КонецОбласти

#Область РасшифровкаСтандартныхОтчетов

// Заполняет настройки расшифровки (см. БухгалтерскиеОтчетыКлиентСервер.НовыйУниверсальныеНастройки) для переданного экземпляра отчета.
//
// Параметры:
//  Настройки				 - Структура								 - Настройки расшифровки отчета, которые нужно заполнить (см. БухгалтерскиеОтчетыКлиентСервер.НовыйУниверсальныеНастройки).
//  Объект					 - ОтчетОбъект								 - Отчет, из данных которого нужно собрать универсальные настройки.
//  ДанныеРасшифровки		 - ДанныеРасшифровкиКомпоновкиДанных		 - Данные расшифровки отчета.
//  ИдентификаторРасшифровки - ИдентификаторРасшифровкиКомпоновкиДанных  - Идентификатор расшифровки из ячейки, для которой вызвана расшифровка.
//  РеквизитыРасшифровки	 - Структура								 - Реквизиты отчета полученные из контекста расшифровываемой ячейки.
//
Процедура ЗаполнитьНастройкиРасшифровки(Настройки, Объект, ДанныеРасшифровки, ИдентификаторРасшифровки, РеквизитыРасшифровки) Экспорт

	БухгалтерскиеОтчетыРасшифровка.ЗаполнитьНастройкиРасшифровкиПоДаннымСтандартногоОтчета(
		Настройки,
		ДанныеРасшифровки,
		ИдентификаторРасшифровки,
		Объект,
		РеквизитыРасшифровки);
	
КонецПроцедуры

// Адаптирует переданные настройки для данного вида отчетов.
// Перед применением настроек расшифровки может возникнуть необходимость учесть особенности этого вида отчетов.
//
// Параметры:
//  Настройки	 - Структура - Настройки которые нужно адаптировать (см. БухгалтерскиеОтчетыКлиентСервер.НовыйУниверсальныеНастройки).
//
Процедура АдаптироватьНастройки(Настройки) Экспорт
	
КонецПроцедуры

// Устанавливает какими отчетами и при каких условиях может быть расшифрован этот вид отчетов.
//
// Параметры:
//  Правила - ТаблицаЗначений с правилами расшифровки этого отчета см. БухгалтерскиеОтчетыРасшифровка.НовыйПравилаРасшифровки.
//
Процедура ЗаполнитьПравилаРасшифровки(Правила) Экспорт

	Правило = Правила.Добавить();
	Правило.Отчет = "ОтчетПоПроводкам";
	Правило.ШаблонПредставления = НСтр("ru = 'Отчет по проводкам'");
		
КонецПроцедуры

#КонецОбласти

#КонецЕсли