﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем мНастройкиИзмерений Экспорт; // Хранит настройки дополнительных измерений.

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)

	СписокПараметровНаФорме = Новый СписокЗначений;
	
	СписокПараметровНаФорме.Добавить("Период");
	СписокПараметровНаФорме.Добавить("Периодичность");
	
	
	Для каждого ЭлементСписка Из СписокПараметровНаФорме Цикл
		
		ИмяПараметра = ЭлементСписка.Значение;
		бит_ОтчетыСервер.УстановитьЗначениеПараметраКомпоновщика(КомпоновщикНастроек, 
																 ЭтотОбъект[ИмяПараметра], 
																 ИмяПараметра);
		
	КонецЦикла;  	
	
КонецПроцедуры // ПриКомпоновкеРезультата()

#КонецОбласти

#Область Инициализация

мНастройкиИзмерений = бит_ОбщиеПеременныеСервер.ЗначениеПеременной("бит_НастройкиДополнительныхИзмерений");

бит_МеханизмДопИзмерений.СформироватьЗаголовкиПолейДополнительныхИзмеренийВСКД(СхемаКомпоновкиДанных, 
					"НаборДанных1", 
					мНастройкиИзмерений);

#КонецОбласти

#КонецЕсли
