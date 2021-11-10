﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс
	
// Процедура инициализирует компоновщик, используемый для получения дерева заместителей.
// 
Функция ИнициализироватьКомпоновщик(Компоновщик, УникальныйИдентификатор, ЭтоАдминистратор) Экспорт
	
	СКД = Обработки.бит_НазначениеЗаместителей.ПолучитьМакет("СКД");
	
	Если НЕ ЭтоАдминистратор Тогда
	
		// Удаляем отбор по пользователю
		ЭО = Неопределено;
		Для каждого ТекЭО Из СКД.НастройкиПоУмолчанию.Отбор.Элементы Цикл
		
			Если Строка(ТекЭО.ЛевоеЗначение) = "Пользователь" Тогда
			
				ЭО = ТекЭО;
				Прервать;
			
			КонецЕсли; 
		
		КонецЦикла; 
		
		Если НЕ ЭО = Неопределено Тогда
		
			СКД.НастройкиПоУмолчанию.Отбор.Элементы.Удалить(ЭО);
		
		КонецЕсли; 
		
		// Запрещаем использование пользователя в качестве поля отбора.
		ПолеПользователь = Неопределено;
		Для каждого ТекПоле Из СКД.НаборыДанных.НаборДанных1.Поля Цикл
			
			Если ТекПоле.ПутьКДанным = "Пользователь" Тогда
				
				 ПолеПользователь = ТекПоле;
				 Прервать;
				
			КонецЕсли; 
			
		КонецЦикла; 
		
		Если НЕ ПолеПользователь = Неопределено Тогда
		
			ПолеПользователь.ОграничениеИспользования.Условие = Истина;
			ПолеПользователь.ОграничениеИспользованияРеквизитов.Условие = Истина;
		
		КонецЕсли; 
		
	КонецЕсли; 
	
	АдресСКД = ПоместитьВоВременноеХранилище(СКД, УникальныйИдентификатор);
	
	// Инициализируем компоновщик
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСКД);
	Компоновщик.Инициализировать(ИсточникНастроек);		
	Компоновщик.ЗагрузитьНастройки(СКД.НастройкиПоУмолчанию);
	
	Возврат АдресСКД;
	
КонецФункции // ИнициализироватьКомпоновщик()

// Функция получает дерево заместителей.
// 
// Параметры:
//  Компоновщик - КомпоновщикНастроекКомпоновкиДанных.
//  АдресСКД - Строка.
// 
// Возвращаемое значение:
//  ДеревоДанных - ДеревоЗначений.
// 
Функция НастройкиЗаместителей(Компоновщик, АдресСКД) Экспорт
	
	ДеревоДанных = Новый ДеревоЗначений;
	
	Если ЭтоАдресВременногоХранилища(АдресСКД) Тогда
		
		СКД = ПолучитьИзВременногоХранилища(АдресСКД);
		
		КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
		
		// Передаем в макет компоновки схему, настройки и данные расшифровки.
		МакетКомпоновки = КомпоновщикМакета.Выполнить(СКД, Компоновщик.ПолучитьНастройки(), , ,
		                                               Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
		
		// Выполним компоновку с помощью процессора компоновки.
		ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
		ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки);
		
		// Вывод таблицы   	
		ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
		ПроцессорВывода.УстановитьОбъект(ДеревоДанных); 	
		ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
		
	КонецЕсли; 
	
	Возврат ДеревоДанных;
	
КонецФункции // ПолучитьДерево()

#КонецОбласти
 
#КонецЕсли
