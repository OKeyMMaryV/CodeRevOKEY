﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Функция НайтиГруппировку(Структура, Имя)
	
	Для каждого Элемент Из Структура Цикл
		
		Для каждого Поле Из Элемент.ПоляГруппировки.Элементы Цикл
			Если Не ТипЗнч(Поле) = Тип("АвтоПолеГруппировкиКомпоновкиДанных") Тогда
				Если Поле.Поле = Новый ПолеКомпоновкиДанных(Имя) Тогда
					Возврат Элемент;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		Если Элемент.Структура.Количество() = 0 Тогда
			Возврат Неопределено;
		Иначе
			Группировка = НайтиГруппировку(Элемент.Структура, Имя);
		КонецЕсли;
	КонецЦикла;
	Возврат Группировка;
	
КонецФункции

Процедура ДобавитьВыбранноеПолеИлиГруппу(Поле,Выбор)
	
	Если ТипЗнч(Поле) = Тип("ВыбранноеПолеКомпоновкиДанных") Тогда
		ВыборГруппировки =  Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		ЗаполнитьЗначенияСвойств(ВыборГруппировки,Поле);
	ИначеЕсли ТипЗнч(Поле) = Тип("ГруппаВыбранныхПолейКомпоновкиДанных") Тогда
		ВыборГруппировки =  Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ЗаполнитьЗначенияСвойств(ВыборГруппировки,Поле);
		Для Каждого ПолеГруппы Из Поле.Элементы  Цикл
			ДобавитьВыбранноеПолеИлиГруппу(ПолеГруппы,ВыборГруппировки);
		КонецЦикла;	
	КонецЕсли;
	
КонецПроцедуры	

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИспользоватьПередКомпоновкойМакета", Истина);
	Результат.Вставить("ИспользоватьПослеВыводаРезультата",  Истина);
	Результат.Вставить("ИспользоватьДанныеРасшифровки",      Истина);
	Результат.Вставить("ИспользоватьВнешниеНаборыДанных",    Ложь);
	Результат.Вставить("ИспользоватьПривилегированныйРежим", Ложь);

	Возврат Результат;

КонецФункции

Функция ПолучитьТекстЗаголовка(ПараметрыОтчета) Экспорт 
	
	Возврат "Состав уведомления";
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	ПредопределенныеНастройки = ПараметрыОтчета.СхемаКомпоновкиДанных.ВариантыНастроек[0].Настройки;
	
	КомпоновщикНастроек.Настройки.Структура.Очистить();
	КомпоновщикНастроек.Настройки.Выбор.Элементы.Очистить();
		
	Таблица = КомпоновщикНастроек.Настройки.Структура.Добавить(Тип("ТаблицаКомпоновкиДанных"));
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.ОтчетныйГод) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Уведомление", ПараметрыОтчета.Уведомление);
	КонецЕсли;
	
	
	КолонкаДоходы = Таблица.Колонки.Добавить();
	КолонкаДоходы.Имя           = "Доходы";
	
	КолонкаРасходы = Таблица.Колонки.Добавить();
	КолонкаРасходы.Имя           = "Расходы";
	
	
	//Показатели Доходы
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(КолонкаДоходы.Выбор, "СуммаДоходов");

	//Показатели Расходы
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(КолонкаРасходы.Выбор, "СуммаРасходов");
	
	Структура =  Новый Структура("Структура",Таблица.Строки);
	
	КоличествоГруппировок = 0;
	Для Каждого ПолеВыбраннойГруппировки Из ПараметрыОтчета.Группировка Цикл 
		Если ПолеВыбраннойГруппировки.Использование Тогда
			Структура = Структура.Структура.Добавить();
			
			ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
			ПолеГруппировки.Использование  = Истина;
			ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных(ПолеВыбраннойГруппировки.Поле);
			
			Если ПолеВыбраннойГруппировки.ТипГруппировки = 1 Тогда
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия;
			ИначеЕсли ПолеВыбраннойГруппировки.ТипГруппировки = 2 Тогда
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.ТолькоИерархия;
			Иначе
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
			КонецЕсли;
			
			Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
			ПолеСуммы = Структура.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
			
			
			Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
						
			КоличествоГруппировок = КоличествоГруппировок + 1;
		КонецЕсли;
	КонецЦикла;
	
	//Добавляем предопределенные недоступные группировки (всегда в конце)
	
	ПредопределеннаяГруппировка = ПредопределенныеНастройки.Структура[0].Строки;
	Пока ПредопределеннаяГруппировка.Количество() > 0 Цикл
		
		Если ПредопределеннаяГруппировка[0].ПоляГруппировки.Элементы.Количество() > 0 Тогда
			
			Если ПредопределеннаяГруппировка[0].РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный и ПредопределеннаяГруппировка[0].Состояние = СостояниеЭлементаНастройкиКомпоновкиДанных.Включен Тогда
				Структура = Структура.Структура.Добавить();
				
				//Поля группировок
				Для Каждого ПолеПредопределеннойГруппировки Из ПредопределеннаяГруппировка[0].ПоляГруппировки.Элементы Цикл
					Если Тип(ПолеПредопределеннойГруппировки) = Тип("АвтоПолеГруппировкиКомпоновкиДанных") Тогда
						ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("АвтоПолеГруппировкиКомпоновкиДанных"));
					Иначе
						Если НайтиГруппировку(Таблица.Строки, ПолеПредопределеннойГруппировки.Поле) = Неопределено Тогда
							ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
							ЗаполнитьЗначенияСвойств(ПолеГруппировки,ПолеПредопределеннойГруппировки);
						КонецЕсли;
					КонецЕсли;
				КонецЦикла;	
				
				//Отборы
				Для Каждого ОтборПредопределеннойГруппировки Из ПредопределеннаяГруппировка[0].Отбор.Элементы Цикл
					ОтборГруппировки =  Структура.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
					ЗаполнитьЗначенияСвойств(ОтборГруппировки,ОтборПредопределеннойГруппировки);
				КонецЦикла;	
				
				//Условное оформление
				Для Каждого УсловноеОформлениеПредопределеннойГруппировки Из ПредопределеннаяГруппировка[0].УсловноеОформление.Элементы Цикл
					УсловноеОформлениеГруппировки =  Структура.УсловноеОформление.Элементы.Добавить();
					ЗаполнитьЗначенияСвойств(УсловноеОформлениеГруппировки,УсловноеОформлениеПредопределеннойГруппировки);
					
					//Отбор
					Для Каждого ОтборПредопределенногоОформления Из УсловноеОформлениеПредопределеннойГруппировки.Отбор.Элементы Цикл
						ОтборОформления =  УсловноеОформлениеГруппировки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
						ЗаполнитьЗначенияСвойств(ОтборОформления,ОтборПредопределенногоОформления);
					КонецЦикла;	
					
					//Параметры оформления
					Для ИндексПараметра = 0 По УсловноеОформлениеПредопределеннойГруппировки.Оформление.Элементы.Количество() - 1 Цикл
						ОформлениеПредопределеннаяГруппировка = УсловноеОформлениеПредопределеннойГруппировки.Оформление.Элементы[ИндексПараметра];
						ОформлениеГруппировки =  УсловноеОформлениеГруппировки.Оформление.Элементы[ИндексПараметра];
						ЗаполнитьЗначенияСвойств(ОформлениеГруппировки,ОформлениеПредопределеннаяГруппировка);
					КонецЦикла;	
					
					Для Каждого ПредопределенноеОформляемоеПолеГруппировки Из УсловноеОформлениеПредопределеннойГруппировки.Поля.Элементы Цикл
						ОформляемоеПоле = УсловноеОформлениеГруппировки.Поля.Элементы.Добавить();
						ЗаполнитьЗначенияСвойств(ОформляемоеПоле,ПредопределенноеОформляемоеПолеГруппировки);
					КонецЦикла;	
					
				КонецЦикла;	
				
				//Выбор
				Для Каждого ВыборПредопределеннойГруппировки Из ПредопределеннаяГруппировка[0].Выбор.Элементы Цикл
					Если Тип(ВыборПредопределеннойГруппировки) = Тип("АвтоВыбранноеПолеКомпоновкиДанных") Тогда
						Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));	
					Иначе
						Если НайтиГруппировку(Таблица.Строки, ВыборПредопределеннойГруппировки.Поле) = Неопределено Тогда
							ДобавитьВыбранноеПолеИлиГруппу(ВыборПредопределеннойГруппировки,Структура.Выбор);	
						КонецЕсли;
					КонецЕсли;
				КонецЦикла;	
				
				//Порядок
				Для Каждого ПорядокПредопределеннойГруппировки Из ПредопределеннаяГруппировка[0].Порядок.Элементы Цикл
					Если Тип(ПорядокПредопределеннойГруппировки) = Тип("АвтоЭлементПорядкаКомпоновкиДанных") Тогда
						Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));	
					Иначе	
						ПорядокГруппировки =  Структура.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
						ЗаполнитьЗначенияСвойств(ПорядокГруппировки,ПорядокПредопределеннойГруппировки);
					КонецЕсли;
				КонецЦикла;	
				
				//Параметры вывода
				Для ИндексПараметра = 0 По ПредопределеннаяГруппировка[0].ПараметрыВывода.Элементы.Количество() - 1 Цикл
					ПараметрыВыводаПредопределеннаяГруппировка = ПредопределеннаяГруппировка[0].ПараметрыВывода.Элементы[ИндексПараметра];
					ПараметрыВыводаГруппировки =  Структура.ПараметрыВывода.Элементы[ИндексПараметра];
					ЗаполнитьЗначенияСвойств(ПараметрыВыводаГруппировки,ПараметрыВыводаПредопределеннаяГруппировка);
				КонецЦикла;	
				
			КонецЕсли;
		КонецЕсли;
		
		ПредопределеннаяГруппировка = ПредопределеннаяГруппировка[0].Структура;
		
	КонецЦикла;
	
	// Дополнительные данные
	БухгалтерскиеОтчетыВызовСервера.ДобавитьДополнительныеПоля(ПараметрыОтчета, КомпоновщикНастроек);
					
КонецПроцедуры

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);
	
	Если Результат.Области.Найти("Заголовок") = Неопределено Тогда
		Результат.ФиксацияСверху = 0;
	Иначе
		Результат.ФиксацияСверху = Результат.Области.Заголовок.Низ;
	КонецЕсли;
	Результат.ФиксацияСлева = 0;
	
КонецПроцедуры

Функция ПолучитьНаборПоказателей() Экспорт
	
	НаборПоказателей = Новый Массив;
	НаборПоказателей.Добавить("БУ");
	НаборПоказателей.Добавить("НУ");
	НаборПоказателей.Добавить("ПР");
	НаборПоказателей.Добавить("ВР");
	
	Возврат НаборПоказателей;
	
КонецФункции

#КонецЕсли
