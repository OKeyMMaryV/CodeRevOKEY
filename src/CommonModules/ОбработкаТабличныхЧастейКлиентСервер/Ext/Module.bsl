// Рассчитывает сумму в строке табличной части документа
//
// Параметры:
//  СтрокаТабличнойЧасти - строка табличной части документа
//
Процедура РассчитатьСуммуТабЧасти(СтрокаТабличнойЧасти, ЗначениеПустогоКоличества = 0) Экспорт

	СтрокаТабличнойЧасти.Сумма = СтрокаТабличнойЧасти.Цена * ?(СтрокаТабличнойЧасти.Количество = 0, ЗначениеПустогоКоличества, СтрокаТабличнойЧасти.Количество);

КонецПроцедуры

// Рассчитывает сумму в строке табличной части документа
//
// Параметры:
//  СтрокаТабличнойЧасти - строка табличной части документа
//
Процедура РассчитатьСуммуВРозницеТабЧасти(СтрокаТабличнойЧасти, ЗначениеПустогоКоличества = 0) Экспорт

	СтрокаТабличнойЧасти.СуммаВРознице = СтрокаТабличнойЧасти.ЦенаВРознице * ?(СтрокаТабличнойЧасти.Количество = 0, ЗначениеПустогоКоличества, СтрокаТабличнойЧасти.Количество);

КонецПроцедуры

// Расчет, исходя из постоянной суммы
//
// Параметры:
//  СтрокаТабличнойЧасти - строка табличной части документа.
//
Процедура РассчитатьСуммуНДСТабЧасти(СтрокаТабличнойЧасти, СуммаВключаетНДС = Ложь, ПрименяютсяСтавки4и2 = Ложь) Экспорт

	Если ТипЗнч(СтрокаТабличнойЧасти)=Тип("Структура") Тогда
		Если СтрокаТабличнойЧасти.Свойство("Сумма") И СтрокаТабличнойЧасти.Свойство("СтавкаНДС") Тогда
			СтрокаТабличнойЧасти.СуммаНДС = УчетНДСКлиентСервер.РассчитатьСуммуНДС(
												СтрокаТабличнойЧасти.Сумма - ?(СтрокаТабличнойЧасти.Свойство("СуммаСкидки"), СтрокаТабличнойЧасти.СуммаСкидки, 0),
												СуммаВключаетНДС,
												УчетНДСВызовСервераПовтИсп.ПолучитьСтавкуНДС(СтрокаТабличнойЧасти.СтавкаНДС, ПрименяютсяСтавки4и2));
		КонецЕсли;
	Иначе // Строка табличной части
		Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.СтавкаНДС) Тогда
			СтрокаТабличнойЧасти.СуммаНДС = УчетНДСКлиентСервер.РассчитатьСуммуНДС(
												СтрокаТабличнойЧасти.Сумма,
												СуммаВключаетНДС,
												УчетНДСВызовСервераПовтИсп.ПолучитьСтавкуНДС(СтрокаТабличнойЧасти.СтавкаНДС, ПрименяютсяСтавки4и2));
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

// Функция выполняет поиск первой, удовлетворяющей условию поиска, строки табличной части.
//
// Параметры:
//  ТабличнаяЧасть - табличная часть документа, в которой осуществляется поиск,
//  СтруктураОтбора - структура - задает условие поиска.
//
// Возвращаемое значение: 
//  Строка табличной части - найденная строка табличной части,
//  Неопределено           - строка табличной части не найдена.
//
Функция НайтиСтрокуТабЧасти(Объект, ТабличнаяЧасть, СтруктураОтбора) Экспорт

	СтрокаТабличнойЧасти = Неопределено;
	МассивНайденныхСтрок = Объект[ТабличнаяЧасть].НайтиСтроки(СтруктураОтбора);
	Если МассивНайденныхСтрок.Количество() > 0 Тогда

		// Нашли. Вернем первую найденную строку.
		СтрокаТабличнойЧасти = МассивНайденныхСтрок[0];
	КонецЕсли;

	Возврат СтрокаТабличнойЧасти;

КонецФункции

// Процедура выполняет стандартные действия по расчету плановой суммы
// в строке табличной части документа.
//
// Параметры:
//  СтрокаТабличнойЧасти - строка табличной части документа,
//
Процедура ПересчитатьПлановуюСумму(СтрокаТабличнойЧасти, ЗначениеПустогоКоличества = 0) Экспорт

	СтрокаТабличнойЧасти.СуммаПлановая = 
		?(СтрокаТабличнойЧасти.Количество = 0, ЗначениеПустогоКоличества, СтрокаТабличнойЧасти.Количество)
		* СтрокаТабличнойЧасти.ПлановаяСтоимость;

КонецПроцедуры

Процедура ПриИзмененииСуммыТабЧасти(СтрокаТабличнойЧасти, ЗначениеПустогоКоличества = 0) Экспорт

	РасчетноеКоличество = ?(СтрокаТабличнойЧасти.Количество = 0, ЗначениеПустогоКоличества, СтрокаТабличнойЧасти.Количество);
	Если РасчетноеКоличество = 0 Тогда
		СтрокаТабличнойЧасти.Цена = 0;
	Иначе
		СтрокаТабличнойЧасти.Цена = СтрокаТабличнойЧасти.Сумма / РасчетноеКоличество;
	КонецЕсли; 

КонецПроцедуры

Процедура ПриИзмененииКоличествоЦена(Форма, ИмяТаблицы, ЗначениеПустогоКоличества = 0, ПрименяютсяСтавки4и2 = Ложь) Экспорт

	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	СтрокаТаблицы = Элементы[ИмяТаблицы].ТекущиеДанные;
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуТабЧасти(СтрокаТаблицы, ЗначениеПустогоКоличества);
	
	Если СтрокаТаблицы.Свойство("СуммаНДС") Тогда
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "ПокупательНалоговыйАгентПоНДС")
			И Форма.ПокупательНалоговыйАгентПоНДС = Истина
			И Форма.ВедетсяУчетНДСПоФЗ335 Тогда 
			СтрокаТаблицы.СуммаНДС = 0;
		Иначе
			ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуНДСТабЧасти(СтрокаТаблицы, Объект.СуммаВключаетНДС, ПрименяютсяСтавки4и2);
		КонецЕсли;
	КонецЕсли;

	Если СтрокаТаблицы.Свойство("СуммаВРознице") Тогда
		СтрокаТаблицы.СуммаВРознице = СтрокаТаблицы.Количество * СтрокаТаблицы.ЦенаВРознице;
	КонецЕсли;

	Если СтрокаТаблицы.Свойство("Всего") Тогда
		СтрокаТаблицы.Всего = СтрокаТаблицы.Сумма + ?(Объект.СуммаВключаетНДС, 0, СтрокаТаблицы.СуммаНДС);
	КонецЕсли;

КонецПроцедуры

Процедура ПриИзмененииСумма(Форма, ИмяТаблицы, ЗначениеПустогоКоличества = 0, ПрименяютсяСтавки4и2 = Ложь) Экспорт

	Элементы = Форма.Элементы;
	Объект = Форма.Объект;

	СтрокаТаблицы = Элементы[ИмяТаблицы].ТекущиеДанные;

	Если СтрокаТаблицы.Свойство("Количество") Тогда
		Если (СтрокаТаблицы.Количество = 0) И (ЗначениеПустогоКоличества = 0) Тогда
			СтрокаТаблицы.Цена = 0;
		Иначе
			СтрокаТаблицы.Цена = СтрокаТаблицы.Сумма / ?(СтрокаТаблицы.Количество = 0, ЗначениеПустогоКоличества, СтрокаТаблицы.Количество);
		КонецЕсли;
	КонецЕсли;

	Если СтрокаТаблицы.Свойство("СуммаНДС") Тогда
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "ПокупательНалоговыйАгентПоНДС")
			И Форма.ПокупательНалоговыйАгентПоНДС = Истина
			И Форма.ВедетсяУчетНДСПоФЗ335 Тогда 
			СтрокаТаблицы.СуммаНДС = 0;
		Иначе
			ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуНДСТабЧасти(СтрокаТаблицы, Объект.СуммаВключаетНДС, ПрименяютсяСтавки4и2);
		КонецЕсли;
	КонецЕсли;

	Если СтрокаТаблицы.Свойство("Всего") Тогда
		СтрокаТаблицы.Всего = СтрокаТаблицы.Сумма + ?(Объект.СуммаВключаетНДС, 0, СтрокаТаблицы.СуммаНДС);
	КонецЕсли;

КонецПроцедуры

Процедура ПриИзмененииСтавкаНДС(Форма, ИмяТаблицы, ПрименяютсяСтавки4и2 = Ложь) Экспорт

	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	СтрокаТаблицы = Элементы[ИмяТаблицы].ТекущиеДанные;
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "ПокупательНалоговыйАгентПоНДС")
		И Форма.ПокупательНалоговыйАгентПоНДС = Истина
		И Форма.ВедетсяУчетНДСПоФЗ335 Тогда 
		СтрокаТаблицы.СуммаНДС = 0;
	Иначе
		ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуНДСТабЧасти(СтрокаТаблицы, Объект.СуммаВключаетНДС, ПрименяютсяСтавки4и2);
	КонецЕсли;
	Если СтрокаТаблицы.Свойство("Всего") Тогда
		СтрокаТаблицы.Всего = СтрокаТаблицы.Сумма + ?(Объект.СуммаВключаетНДС, 0, СтрокаТаблицы.СуммаНДС);
	КонецЕсли;

КонецПроцедуры

Процедура ПриИзмененииСуммаНДС(Форма, ИмяТаблицы) Экспорт

	Элементы = Форма.Элементы;
	Объект = Форма.Объект;

	СтрокаТаблицы = Элементы[ИмяТаблицы].ТекущиеДанные;

	Если СтрокаТаблицы.Свойство("Всего") Тогда
		СтрокаТаблицы.Всего = СтрокаТаблицы.Сумма + ?(Объект.СуммаВключаетНДС, 0, СтрокаТаблицы.СуммаНДС);
	КонецЕсли;

КонецПроцедуры