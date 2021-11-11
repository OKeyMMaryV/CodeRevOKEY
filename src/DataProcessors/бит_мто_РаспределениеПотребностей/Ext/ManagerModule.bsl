﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс
	
// Функция инициализирует компоновщик.
// 
// Параметры:
//  Компоновщик              		- КомпоновщикНастроекСхемыКомпоновкиДанных.
//  УникальныйИдентификатор  		- УникальныйИдентификатор.
// 	ИмяМакета				 		- Строка.
// 
// Возвращаемое значение:
//   АдресСхемыКомпоновкиДанных   	- Строка.
// 
Функция ИнициализироватьКомпоновщик(Компоновщик, УникальныйИдентификатор, ИмяМакета) Экспорт

	СхемаКомпоновкиДанных = Обработки.бит_мто_РаспределениеПотребностей.ПолучитьМакет(ИмяМакета);
	АдресСхемыКомпоновкиДанных = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, УникальныйИдентификатор);
	
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновкиДанных);
	
    Компоновщик.Инициализировать(ИсточникНастроек);
	Компоновщик.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);

	Возврат АдресСхемыКомпоновкиДанных;
	
КонецФункции // ИнициализироватьКомпоновщик()

// Функция выполняет запрос по настройке компновщика.
// 
// Параметры:
//  Компоновщик - КомпоновщикНастроекКомпоновкиДанных.
//  АдресСхемыКомпоновкиДанных - Строка.
//  СтруктураПараметров - Структура.
// 
// Возвращаемое значение:
//   Результат - РезультатЗапроса.
// 
Функция ВыполнитьЗапросПоНастройке(Компоновщик, АдресСхемыКомпоновкиДанных, ЭлементыУпорядочивания)  Экспорт

	СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресСхемыКомпоновкиДанных);

	// Выполняем компоновку макета МакетСКД
	// (настройки берутся из схемы компоновки данных и из пользовательских настроек).
	КомпоновщикМакетаКомпоновкиДанных = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетСКД = КомпоновщикМакетаКомпоновкиДанных.Выполнить(СхемаКомпоновкиДанных, Компоновщик.ПолучитьНастройки());
	
	// Получаем запрос макета компоновки данных
	Запрос = Новый Запрос(МакетСКД.НаборыДанных.НаборДанных1.Запрос);
	
	// Устанавливаем параметры запроса
	ОписаниеПараметровЗапроса = Запрос.НайтиПараметры();
	Для каждого ОписаниеПараметраЗапроса из ОписаниеПараметровЗапроса Цикл
		Запрос.УстановитьПараметр(ОписаниеПараметраЗапроса.Имя, МакетСКД.ЗначенияПараметров[ОписаниеПараметраЗапроса.Имя].Значение);
	КонецЦикла;
	
	// Заполним параметры
	Запрос.УстановитьПараметр("НачалоПериода", МакетСКД.ЗначенияПараметров.НачалоПериода.Значение);
	Запрос.УстановитьПараметр("КонецПериода", МакетСКД.ЗначенияПараметров.КонецПериода.Значение);
	
	Результат = Запрос.Выполнить().Выгрузить();

	Если Компоновщик.ПолучитьНастройки().Порядок.Элементы.Количество()>0 Тогда
	
		ЭлементыУпорядочивания = Компоновщик.ПолучитьНастройки().Порядок.Элементы;
		
	КонецЕсли; 
	
	Возврат Результат;
	
КонецФункции // ВыполнитьЗапросПоНастройке()

#КонецОбласти
 
#КонецЕсли
