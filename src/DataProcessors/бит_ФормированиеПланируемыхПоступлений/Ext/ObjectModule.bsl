#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОписаниеПеременных

Перем мИзмеренияДоп Экспорт; // Хранит дополнительные измерения регистра ПланируемоеПоступлениеДенежныхСредств.
Перем мНастройкиИзмерений Экспорт; // Хранит настройки дополнительных измерений.

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Функция инициализирует схему компоновки данных и пользовательские настройки.
// 
// Параметры:
// 	пКомпоновщик - КомпоновщикНастроекКомпоновкиДанных - настройки которые будут заполнены из макета СКД.
// 
// Возвращаемое значение:
// 	АдресСхемыКомпоновкиДанных - строка - адрес временного хранилища, где хранится СКД.
// 
&НаСервере
Функция ИнициализироватьКомпоновщик(пКомпоновщик) Экспорт
	
	СхемаКомпоновкиДанных = ПолучитьМакет("СКДПереченьДокументов");
	
	АдресСхемыКомпоновкиДанных = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, Новый УникальныйИдентификатор);
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновкиДанных);
	
	пКомпоновщик.Инициализировать(ИсточникНастроек);
	пКомпоновщик.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);

	Возврат АдресСхемыКомпоновкиДанных;
	
КонецФункции

// Функция создает структуру, хранящую настройки.
// 
// Параметры:
//   Объект.
// Возвращаемое значение:
//   СтруктураНастроек - Структура.
// 
Функция УпаковатьНастройкиВСтруктуруМодуль(Объект) Экспорт

	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("Период"			, Объект.Период);
	СтруктураНастроек.Вставить("РежимСообщений"	, Объект.РежимСообщений);
	СтруктураНастроек.Вставить("РежимЗаписи"	, Объект.РежимЗаписи);
	СтруктураНастроек.Вставить("ОтображатьЭталонныеЗначения", Объект.ОтображатьЭталонныеЗначения);
 	  	
	СтруктураНастроек.Вставить("ПользовательскиеНастройки", Объект.КомпоновщикНастроек.ПользовательскиеНастройки);
			
	Возврат СтруктураНастроек;
	
КонецФункции // УпаковатьНастройкиВСтруктуруМодуль()

// Функция создает структуру, хранящую настройки.
// 
// Параметры:
//   Объект.
//   СтруктураНастроек - Структура.
// 
Процедура РаспоковатьНастройкиИзСтруктурыМодуль(Объект, СтруктураНастроек) Экспорт

	СтруктураНастроек.Свойство("Период"			, Объект.Период);
	СтруктураНастроек.Свойство("РежимСообщений"	, Объект.РежимСообщений);
	СтруктураНастроек.Свойство("РежимЗаписи"	, Объект.РежимЗаписи);
	СтруктураНастроек.Свойство("ОтображатьЭталонныеЗначения", Объект.ОтображатьЭталонныеЗначения);
	
	// Загрузка пользовательских настроек в компоновщик.
	ПользовательскиеНастройки = СтруктураНастроек.ПользовательскиеНастройки;
	Объект.КомпоновщикНастроек.ЗагрузитьПользовательскиеНастройки(ПользовательскиеНастройки);
	
КонецПроцедуры // РаспоковатьНастройкиИзСтруктурыМодуль()

#КонецОбласти

#Область Инициализация

мИзмеренияДоп       = бит_Бюджетирование.ПолучитьИзмеренияБюджетирования("Дополнительные","Синоним");
мНастройкиИзмерений = бит_ОбщиеПеременныеСервер.ЗначениеПеременной("бит_НастройкиДополнительныхИзмерений");

#КонецОбласти

#КонецЕсли
